output "vpn_gateway_name" {
  value = google_compute_vpn_gateway.vpn_gateway.name
}

output "vpn_gateway_self_link" {
  value = google_compute_vpn_gateway.vpn_gateway.self_link
}
