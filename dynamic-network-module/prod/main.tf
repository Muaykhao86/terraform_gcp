terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.28.0"
    }
  }
}

provider "google" {
  project = "test-422914"
}


module "network" {
  source = "../modules/networking"
  environment = "prod"
  cidr_range = "10.0.0.0/8"
  regions = ["us-central1", "us-east1", "us-east4", "us-west1"]
  subnet_size = 24
}