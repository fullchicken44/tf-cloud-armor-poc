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


#   source                                 = "./modules/vpc"
#   project_id                             = "my-second-project-445004"
#   network_name                           = "vpc2"
#   auto_create_subnetworks                = false
#   shared_vpc_host                        = false
#   delete_default_internet_gateway_routes = false
# }
