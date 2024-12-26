variable "ipsec_secret_length" {
  type        = number
  description = "The lnegth the of shared secret for VPN tunnels"
  default     = 8
}

variable "cr_enabled" {
  type        = bool
  description = "If there is a cloud router for BGP routing"
  default     = false
}

variable "tunnel_count" {
  type        = number
  description = "The number of tunnels from each VPN gw (default is 1)"
  default     = 1
}

variable "region" {
  type        = string
  description = "The region in which you want to create the vpn gateway"
}

variable "project_id" {
  type        = string
  description = "id of the project"
}

variable "peer_ips" {
  type        = list(string)
  description = "IP address of remote-peer/gateway"
}

variable "local_traffic_selector" {
  description = <<EOD
Local traffic selector to use when establishing the VPN tunnel with peer VPN gateway.
Value should be list of CIDR formatted strings and ranges should be disjoint.
EOD


  type    = list(string)
  default = ["0.0.0.0/0"]
}

variable "remote_traffic_selector" {
  description = <<EOD
Remote traffic selector to use when establishing the VPN tunnel with peer VPN gateway.
Value should be list of CIDR formatted strings and ranges should be disjoint.
EOD


  type    = list(string)
  default = ["0.0.0.0/0"]
}

variable "ike_version" {
  type        = number
  description = "Please enter the IKE version used by this tunnel (default is IKEv2)"
  default     = 2
}

variable "forwarding_rules" {
  type        = map(any)
  description = "Map of forwarding rules to depend on"
}

variable "vpn_gateway_self_link" {
  type = string
}

variable "default_shared_secret" {
  type = string
}

variable "tunnel_name_prefix" {
  type = string
}

variable "cr_name" {
  type        = string
  description = "The name of cloud router for BGP routing"
  default     = ""
}
