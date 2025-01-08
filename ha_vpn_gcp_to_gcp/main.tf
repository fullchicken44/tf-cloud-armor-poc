# # Create VPC 1
# module "vpc1" {
#   source                                    = "./modules/vpc"
#   project_id                                = "amazing-city-438803-e9"
#   network_name                              = "vpc1"
#   routing_mode                              = "GLOBAL"
#   shared_vpc_host                           = false
#   auto_create_subnetworks                   = false
#   delete_default_internet_gateway_routes    = false
# }
#
# # Create "vpc2"
# module "vpc2" {
#   source                                    = "./modules/vpc"
#   project_id                                = "my-second-project-445004"
#   network_name                              = "vpc2"
# }
#
# module "vpn_ha-1" {
#   source            = "./modules/vpn_ha"
#   version           = "~> 4.0"
#   project_id        = "amazing-city-438803-e9"
#   region            = "asia-southeast1"
#   network           = module.vpc1.self_link 
#   name              = "net1-to-net-2"
#   peer_gcp_gateway  = module.vpn_ha-2.self_link
#   router_asn        = 64514
#
#   tunnels = {
#     remote-0 = {
#       bgp_peer = {
#         address = "169.254.1.1"
#         asn     = 64513
#       }
#       bgp_peer_options                = null
#       bgp_session_range               = "169.254.1.2/30"
#       ike_version                     = 2
#       vpn_gateway_interface           = 0
#       peer_external_gateway_interface = null
#       shared_secret                   = ""
#     }
#
#     remote-1 = {
#       bgp_peer = {
#         address = "169.254.2.1"
#         asn     = 64513
#       }
#       bgp_peer_options                = null
#       bgp_session_range               = "169.254.2.2/30"
#       ike_version                     = 2
#       vpn_gateway_interface           = 1
#       peer_external_gateway_interface = null
#       shared_secret                   = ""
#     }
#
#   }
# }
#
# module "vpn_ha-2" {
#   source              = "./modules/vpn_ha" 
#   version             = "~> 4.0"
#   project_id          = "my-second-project-445004"
#   region              = "asia-southeast1"
#   network             = module.vpc2.self_link 
#   name                = "net2-to-net1"
#   router_asn          = 64513
#   peer_gcp_gateway    = module.vpn_ha-1.self_link
#
#   tunnels = {
#     remote-0 = {
#       bgp_peer = {
#         address = "169.254.1.2"
#         asn     = 64514
#       }
#       bgp_session_range               = "169.254.1.1/30"
#       ike_version                     = 2
#       vpn_gateway_interface           = 0
#       shared_secret                   = module.vpn_ha-1.random_secret
#     }
#
#     remote-1 = {
#       bgp_peer = {
#         address = "169.254.2.2"
#         asn     = 64514
#       }
#       bgp_session_range               = "169.254.2.1/30"
#       ike_version                     = 2
#       vpn_gateway_interface           = 1
#       shared_secret                   = module.vpn_ha-1.random_secret
#     }
#
#   }
# }
