# Create VPC 1
module "vpc1" {
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
