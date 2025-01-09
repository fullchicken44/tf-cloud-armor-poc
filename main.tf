# Configure the Google Cloud provider
terraform {
  required_version = ">= 1.3"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.64, < 7"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = ">= 4.64, < 7"
    }
  }
}

provider "google" {
  project = "int-pso-lab-terraform" # Replace with your GCP project ID
  region  = "asia-southeast1"       # Replace with your desired region
  zone    = "asia-southeast-a"      # Replace with your desired zone
}


#   name         = "simple-instance"
#   machine_type = "e2-medium"
#   zone         = "us-central1-a"
#   boot_disk {
#     auto_delete = true
#     device_name = "instance-20241230-041646"
#
#     initialize_params {
#       image = "projects/debian-cloud/global/images/debian-12-bookworm-v20241210"
#       size  = 10
#       type  = "pd-balanced"
#     }
#
#     mode = "READ_WRITE"
#   }
#
#   network_interface {
#     network = "default"
#   }
# }

# Create VPC 1
module "vpc1" {
  source                                 = "./modules/vpc"
  project_id                             = "int-pso-lab-terraform"
  network_name                           = "vpc1"
  routing_mode                           = "GLOBAL"
  shared_vpc_host                        = false
  auto_create_subnetworks                = false
  delete_default_internet_gateway_routes = false
}

resource "google_compute_firewall" "default" {
  name    = "test-firewall"
  network = "vpc1"

  allow {
    protocol = "icmp"
  }
  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }

  source_ranges = ["172.1.2.3/32"]

  source_tags = ["foo"]
  target_tags = ["web"]
}

# Create VP2
module "vpc2" {
  source                                 = "./modules/vpc"
  project_id                             = "int-pso-lab-terraform"
  network_name                           = "vpc2"
  routing_mode                           = "GLOBAL"
  shared_vpc_host                        = false
  auto_create_subnetworks                = false
  delete_default_internet_gateway_routes = false
}

resource "google_compute_firewall" "default2" {
  name    = "test-firewall2"
  network = "vpc2"

  allow {
    protocol = "icmp"
  }
  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }

  source_ranges = ["172.1.2.3/32"]

  source_tags = ["foo"]
  target_tags = ["web"]
}

module "vpn_ha-1" {
  source           = "./modules/vpn_ha"
  project_id       = "int-pso-lab-terraform"
  region           = "asia-southeast1"
  network          = module.vpc1.network_self_link
  name             = "net1-to-net-2"
  peer_gcp_gateway = module.vpn_ha-2.self_link
  router_asn       = 64514

  tunnels = {
    remote-0 = {
      bgp_peer = {
        address = "169.254.1.1"
        asn     = 64513
      }
      bgp_peer_options                = null
      bgp_session_range               = "169.254.1.2/30"
      ike_version                     = 2
      vpn_gateway_interface           = 0
      peer_external_gateway_interface = null
      shared_secret                   = ""
    }

    remote-1 = {
      bgp_peer = {
        address = "169.254.2.1"
        asn     = 64513
      }
      bgp_peer_options                = null
      bgp_session_range               = "169.254.2.2/30"
      ike_version                     = 2
      vpn_gateway_interface           = 1
      peer_external_gateway_interface = null
      shared_secret                   = ""
    }

  }
}

module "vpn_ha-2" {
  source           = "./modules/vpn_ha"
  project_id       = "int-pso-lab-terraform"
  region           = "asia-southeast1"
  network          = module.vpc2.network_self_link
  name             = "net2-to-net1"
  router_asn       = 64513
  peer_gcp_gateway = module.vpn_ha-1.self_link

  tunnels = {
    remote-0 = {
      bgp_peer = {
        address = "169.254.1.2"
        asn     = 64514
      }
      bgp_session_range     = "169.254.1.1/30"
      ike_version           = 2
      vpn_gateway_interface = 0
      shared_secret         = module.vpn_ha-1.random_secret
    }

    remote-1 = {
      bgp_peer = {
        address = "169.254.2.2"
        asn     = 64514
      }
      bgp_session_range     = "169.254.2.1/30"
      ike_version           = 2
      vpn_gateway_interface = 1
      shared_secret         = module.vpn_ha-1.random_secret
    }

  }
}



