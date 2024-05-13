variable "subnet_size" {
    type = number
}

variable "regions" {
  type = list(string)
  description= "The regions where subnets should be created"
}

variable "cidr_range" {
  description = "The range of IP addresses for this VPC"
}

variable "environment" {
    description = "The stage of workloads that will be deployed to this network"
}

# Works out the number of bits to add to the CIDR range
locals {
    split_cidr = split("/", var.cidr_range)
    cidr_size = element(local.split_cidr, length(local.split_cidr) - 1)
    newbits = var.subnet_size - tonumber(local.cidr_size)
}

resource "google_compute_network" "vpc" {
  name                    = "${var.environment}-vpc"
  auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "subnet" {
  count         = length(var.regions)
  name          = "${var.environment}-subnet-${var.regions[count.index]}"
  region        = var.regions[count.index]
  network       = google_compute_network.vpc.name
  # The count.index grabs the output of the cidrsubnet function which is a list of subnets produced
  ip_cidr_range = cidrsubnet(var.cidr_range, local.newbits, count.index)
}


