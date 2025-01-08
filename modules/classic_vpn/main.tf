locals {
  tunnel_name_prefix    = var.tunnel_name_prefix != "" ? var.tunnel_name_prefix : "${var.network_name}-${var.gateway_name}-tunnel"
  default_shared_secret = var.shared_secret != "" ? var.shared_secret : random_id.ipsec_secret.b64_url
}

module "vpc" {
  source                                    = "./modules/vpc"
  project_id                                = var.project_id
  network_name                              = var.network_name
  routing_mode                              = var.routing_mode
  shared_vpc_host                           = var.shared_vpc_host
  auto_create_subnetworks                   = var.auto_create_subnetworks
  delete_default_internet_gateway_routes    = var.delete_default_internet_gateway_routes
  mtu                                       = var.mtu
  enable_ipv6_ula                           = var.enable_ipv6_ula
  internal_ipv6_range                       = var.internal_ipv6_range
  network_firewall_policy_enforcement_order = var.network_firewall_policy_enforcement_order
}

module "vpn_gateway" {
  source       = "./modules/vpn_gateway"
  gateway_name = var.gateway_name
  region       = var.region
  network_id   = google_compute_network.vpc.network_id
  project_id   = var.project_id
  vpn_gw_ip    = var.vpn_gw_ip
}

module "forwarding_rules" {
  source           = "./modules/forwarding_rules/"
  project_id       = var.project_id
  vpn_gw_self_link = module.vpn_gateway.vpn_gateway_self_link
  region           = var.region
}

module "tunnel" {
  source                = "./modules/vpn_tunnel/"
  tunnel_name_prefix    = local.tunnel_name_prefix
  vpn_gateway_self_link = module.vpn_gateway.vpn_gateway_self_link
  peer_ips              = var.peer_ips
  region                = var.region
  project_id            = var.project_id
  default_shared_secret = local.default_shared_secret
  forwarding_rules = {
    esp     = module.forwarding_rules.forwarding_rule_esp
    udp500  = module.forwarding_rules.forwarding_rule_udp500
    udp4500 = module.forwarding_rules.udp4500
  }
}

# For VPN gateways with static routing
## Create Route (for static routing gateways)
resource "google_compute_route" "route" {
  count      = !var.cr_enabled ? var.tunnel_count * length(var.remote_subnet) : 0
  name       = "${module.vpn_gateway.gateway_name}-tunnel${floor(count.index / length(var.remote_subnet)) + 1}-route${count.index % length(var.remote_subnet) + 1}"
  network    = module.vpc.network_name
  project    = var.project_id
  dest_range = var.remote_subnet[count.index % length(var.remote_subnet)]
  priority   = var.route_priority
  tags       = var.route_tags

  next_hop_vpn_tunnel = module.tunnel.tunnel-static[floor(count.index / length(var.remote_subnet))].self_link

  depends_on = [module.tunnel.tunnel-static]
}

# For VPN gateways routing through BGP and Cloud Routers
## Create Router Interfaces
resource "google_compute_router_interface" "router_interface" {
  count      = var.cr_enabled ? var.tunnel_count : 0
  name       = "interface-${local.tunnel_name_prefix}-${count.index}"
  router     = var.cr_name
  region     = var.region
  ip_range   = var.bgp_cr_session_range[count.index]
  vpn_tunnel = module.tunnel.tunnel-dynamic[count.index].name
  project    = var.project_id

  depends_on = [module.tunnel.tunnel-dynamic]
}

## Create Peers
resource "google_compute_router_peer" "bgp_peer" {
  count                     = var.cr_enabled ? var.tunnel_count : 0
  name                      = "bgp-session-${local.tunnel_name_prefix}-${count.index}"
  router                    = var.cr_name
  region                    = var.region
  peer_ip_address           = var.bgp_remote_session_range[count.index]
  peer_asn                  = var.peer_asn[count.index]
  advertised_route_priority = var.advertised_route_priority
  interface                 = "interface-${local.tunnel_name_prefix}-${count.index}"
  project                   = var.project_id

  depends_on = [google_compute_router_interface.router_interface]
}
