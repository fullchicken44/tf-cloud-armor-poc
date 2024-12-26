variable "region" {
  type        = string
  description = "The region this gateway should sit in"
}

variable "gateway_name" {
  type        = string
  description = "Name of the gateway"
}

variable "network_id" {
  type        = string
  description = "Id of the network this VPN gateway is accepting traffic for"
}

variable "vpn_gw_ip" {
  type        = string
  description = "Enter public address of the VPN gateway, if you have one already. Do not set this variable "
}

variable "project_id" {
  type        = string
  description = "Id of the project that contains the VPC"
}
