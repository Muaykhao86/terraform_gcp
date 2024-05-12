terraform {
  backend "gcs" {
    bucket = "terraform_dan_test"
    prefix = "instance-module"
  }
}
