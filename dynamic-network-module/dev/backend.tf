terraform {
  backend "gcs" {
    bucket = "terraform_dan_test"
    prefix = "dyn-net-dev/terraform.tfstate"
  }
}
