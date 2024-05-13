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
  source = "../../modules/dynamic-vpc"
  environment = "dev"
  cidr_range = "10.10.0.0/24"
  regions = ["us-central1", "us-east1"]
  subnet_size = 28
}

