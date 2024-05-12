terraform {
  backend "gcs" {
    bucket = "terraform_dan_test"
    prefix = "instance/terraform.tfstate"
  }
}
