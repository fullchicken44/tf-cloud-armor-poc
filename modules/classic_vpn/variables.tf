variable "project_id" {
  type        = string
  description = "The ID of the project where this VPC will be created"
}

variable "network_name" {
  type        = string
  description = "The name of VPC being created"
}

variable "region" {
  type        = string
  description = "The region in which you want to create the VPN gateway"
}

variable "gateway_name" {
  type        = string
  description = "The name of VPN gateway"
  default     = "test-vpn"
}

variable "tunnel_count" {
  type        = number
  description = "The number of tunnels from each VPN gw (default is 1)"
  default     = 1
}

variable "tunnel_name_prefix" {
  type        = string
  description = "The optional custom name of VPN tunnel being created"
  default     = ""
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

variable "peer_ips" {
  type        = list(string)
  description = "IP address of remote-peer/gateway"
}

variable "remote_subnet" {
  description = "remote subnet ip range in CIDR format - x.x.x.x/x"
  type        = list(string)
  default     = []
}

variable "shared_secret" {
  type        = string
  description = "Please enter the shared secret/pre-shared key"
  default     = ""
}

variable "route_priority" {
  description = "Priority for static route being created"
  type        = number
  default     = 1000
}

variable "cr_name" {
  type        = string
  description = "The name of cloud router for BGP routing"
  default     = ""
}

variable "cr_enabled" {
  type        = bool
  description = "If there is a cloud router for BGP routing"
  default     = false
}

variable "peer_asn" {
  type        = list(string)
  description = "Please enter the ASN of the BGP peer that cloud router will use"
  default     = ["65101"]
}

variable "bgp_cr_session_range" {
  type        = list(string)
  description = "Please enter the cloud-router interface IP/Session IP"
  default     = ["169.254.1.1/30", "169.254.1.5/30"]
}

variable "bgp_remote_session_range" {
  type        = list(string)
  description = "Please enter the remote environments BGP Session IP"
  default     = ["169.254.1.2", "169.254.1.6"]
}

variable "advertised_route_priority" {
  description = "Please enter the priority for the advertised route to BGP peer(default is 100)"
  type        = number
  default     = 100
}

variable "ike_version" {
  type        = number
  description = "Please enter the IKE version used by this tunnel (default is IKEv2)"
  default     = 2
}

variable "vpn_gw_ip" {
  type        = string
  description = "Please enter the public IP address of the VPN Gateway, if you have already one. Do not set this variable to autocreate one"
  default     = ""
}

variable "route_tags" {
  type        = list(string)
  description = "A list of instance tags to which this route applies."
  default     = []
}

variable "ipsec_secret_length" {
  type        = number
  description = "The lnegth the of shared secret for VPN tunnels"
  default     = 8
}

# VPC variable
variable "routing_mode" {
  type        = string
  default     = "GLOBAL"
  description = "The network routing mode (default 'GLOBAL')"
}

variable "shared_vpc_host" {
  type        = bool
  description = "Makes this project a Shared VPC host if 'true' (default 'false')"
  default     = false
}

variable "description" {
  type        = string
  description = "An optional description of this resource. The resource must be recreated to modify this field."
  default     = ""
}

variable "auto_create_subnetworks" {
  type        = bool
  description = "When set to true, the network is created in 'auto subnet mode' and it will create a subnet for each region automatically across the 10.128.0.0/9 address range. When set to false, the network is created in 'custom subnet mode' so the user can explicitly connect subnetwork resources."
  default     = false
}

variable "delete_default_internet_gateway_routes" {
  type        = bool
  description = "If set, ensure that all routes within the network specified whose names begin with 'default-route' and with a next hop of 'default-internet-gateway' are deleted"
  default     = false
}

variable "mtu" {
  type        = number
  description = "The network MTU (If set to 0, meaning MTU is unset - defaults to '1460'). Recommended values: 1460 (default for historic reasons), 1500 (Internet default), or 8896 (for Jumbo packets). Allowed are all values in the range 1300 to 8896, inclusively."
  default     = 0
}

variable "enable_ipv6_ula" {
  type        = bool
  description = "Enabled IPv6 ULA, this is a permenant change and cannot be undone! (default 'false')"
  default     = false
}

variable "internal_ipv6_range" {
  type        = string
  default     = null
  description = "When enabling IPv6 ULA, optionally, specify a /48 from fd20::/20 (default null)"
}

variable "network_firewall_policy_enforcement_order" {
  type        = string
  default     = null
  description = "Set the order that Firewall Rules and Firewall Policies are evaluated. Valid values are `BEFORE_CLASSIC_FIREWALL` and `AFTER_CLASSIC_FIREWALL`. (default null or equivalent to `AFTER_CLASSIC_FIREWALL`)"
}

variable "network_profile" {
  type        = string
  default     = null
  description = <<-EOT
    "A full or partial URL of the network profile to apply to this network.
    This field can be set only at resource creation time. For example, the
    following are valid URLs:
      * https://www.googleapis.com/compute/beta/projects/{projectId}/global/networkProfiles/{network_profile_name}
      * projects/{projectId}/global/networkProfiles/{network_profile_name}
    EOT
}

