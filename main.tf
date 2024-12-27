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
  project = "amazing-city-438803-e9" # Replace with your GCP project ID
  region  = "asia-southeast1"        # Replace with your desired region
  zone    = "asia-southeast-a"       # Replace with your desired zone
}

# Create a compute instance
resource "google_compute_instance" "default" {
  name         = "simple-instance"
  machine_type = "e2-medium"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9" # Replace with your desired image
    }
  }

  network_interface {
    network = "default"
  }
}


