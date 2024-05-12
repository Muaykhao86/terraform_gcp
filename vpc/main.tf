module "vpc" {
  source       = "terraform-google-modules/network/google"
  version      = "~> 9.1"
  project_id   = var.project
  network_name = "terraform-vpc"

  subnets = [
    { subnet_name   = "public-1"
      subnet_ip     = var.cidr_ip
      subnet_region = var.region
    },
    { subnet_name           = "private-1"
      subnet_ip             = "10.1.0.0/16"
      subnet_region         = var.region
      google_private_access = true
    }
  ]

  secondary_ranges = {
    subnet-1 = []
    subnet-2 = []
  }
}

module "routes" {
  source       = "terraform-google-modules/network/google//modules/routes"
  project_id   = var.project
  network_name = module.vpc.network_name
  routes = [
    {
      name              = "engress-internet"
      description       = "Route throug IGW to the internet"
      destination_range = "0.0.0.0./0"
      tags              = "engress-internet"
      next_hop_internet = true
    }
  ]

}

module "firewall" {
  source                  = "terraform-google-modules/network/google//modules/fabric-net-firewall"
  project_id              = var.project
  network                 = module.vpc.network_name
  internal_ranges_enabled = true
  internal_ranges         = [var.cidr_ip]
}

