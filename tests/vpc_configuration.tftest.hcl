# tests/vpc_configuration.tftest.hcl
provider "google" {
  project = "int-pso-lab-terraform"
  region  = "asia-southeast1"
  zone    = "asia-southeast-a"
}

run "verify_vpc1_configuration" {
  command = plan

  assert {
    condition     = module.vpc1.network_name == "vpc1"
    error_message = "VPC1 name does not match expected value"
  }

  assert {
    condition     = module.vpc1.routing_mode == "GLOBAL"
    error_message = "VPC1 routing mode should be GLOBAL"
  }

  assert {
    condition     = module.vpc1.auto_create_subnetworks == false
    error_message = "VPC1 auto_create_subnetworks should be false"
  }
}

run "verify_vpc2_configuration" {
  command = plan

  assert {
    condition     = module.vpc2.network_name == "vpc2"
    error_message = "VPC2 name does not match expected value"
  }

  assert {
    condition     = module.vpc2.routing_mode == "GLOBAL"
    error_message = "VPC2 routing mode should be GLOBAL"
  }
}
