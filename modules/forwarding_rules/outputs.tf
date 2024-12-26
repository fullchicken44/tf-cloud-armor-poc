output "forwarding_rule_esp" {
  value = google_compute_forwarding_rule.vpn_esp
}

output "forwarding_rule_udp500" {
  value = google_compute_forwarding_rule.vpn_udp500
}

output "forwarding_rule_udp4500" {
  value = google_compute_forwarding_rule.vpn_udp4500
}
