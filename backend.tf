terraform {
  backend "gcs" {
    bucket = "terraform-state-int-pso-lab-terraform"
    prefix = "terraform/state"
  }
}
