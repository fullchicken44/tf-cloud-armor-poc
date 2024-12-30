terraform {
  backend "gcs" {
    bucket = "terraform-state-amazing-city-438803-e9"
    prefix = "terraform/state"
  }
}
