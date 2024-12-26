resource "random_id" "ipsec_secret" {
  byte_length = var.ipsec_secret_length
}

resource "google_compute_vpn_tunnel" "tunnel-static" {
  count         = !var.cr_enabled ? var.tunnel_count : 0
  name          = var.tunnel_count == 1 ? format("%s-%s", var.tunnel_name_prefix, "1") : format("%s-%d", var.tunnel_name_prefix, count.index + 1)
  region        = var.region
  project       = var.project_id
  peer_ip       = var.peer_ips[count.index]
  shared_secret = var.default_shared_secret

  target_vpn_gateway      = var.vpn_gateway_self_link
  local_traffic_selector  = var.local_traffic_selector
  remote_traffic_selector = var.remote_traffic_selector

  ike_version = var.ike_version

  depends_on = [
    var.forwarding_rules
  ]
}

resource "google_compute_vpn_tunnel" "tunnel-dynamic" {
  count         = var.cr_enabled ? var.tunnel_count : 0
  name          = var.tunnel_count == 1 ? format("%s-%s", var.tunnel_name_prefix, "1") : format("%s-%d", var.tunnel_name_prefix, count.index + 1)
  region        = var.region
  project       = var.project_id
  peer_ip       = var.peer_ips[count.index]
  shared_secret = var.default_shared_secret

  target_vpn_gateway = google_compute_vpn_gateway.vpn_gateway.self_link

  router      = var.cr_name
  ike_version = var.ike_version

  depends_on = [
    var.forwarding_rules
  ]
}
