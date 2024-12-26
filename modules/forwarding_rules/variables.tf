variable "vpn_gw_ip" {
  type        = string
  description = "Enter public address of the VPN gateway, if you have one already. Do not set this variable "
  default     = ""
}

variable "project_id" {
  type        = string
  description = "The project id"
}

variable "region" {
  type        = string
  description = "The region"
}

variable "vpn_gw_self_link" {
  type        = string
  description = "The self-link of the vpn gateway"
}


