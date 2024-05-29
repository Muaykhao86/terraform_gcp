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
    split_cidr = split("/", var.cidr_range) # 10.10.0.0/24
    cidr_size = element(local.split_cidr, length(local.split_cidr) - 1) # ["10.10.0.0/", "24"] => 24
    newbits = var.subnet_size - tonumber(local.cidr_size) # 28 - 24 => 4
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
  ip_cidr_range = cidrsubnet(var.cidr_range, local.newbits, count.index)
  # The count.index grabs the output of the cidrsubnet function which is a list of subnets produced
  # eg
  # cidrsubnet("10.10.0.0/24", 4, 0) - 10.10.0.0/28
  # cidrsubnet("10.10.0.0/24", 4, 1) - 10.10.0.16/28
  # cidrsubnet("10.10.0.0/24", 4, 2) - 10.10.0.32/28
}


