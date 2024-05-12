terraform {
  backend "gcs" {
    bucket = "terraform_dan_test"
    prefix = "lb/terraform.tfstate"
  }
}
