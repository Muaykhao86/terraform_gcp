terraform {
  backend "gcs" {
    bucket = "terraform_dan_test"
    prefix = "dyn-net-prod/terraform.tfstate"
  }
}
