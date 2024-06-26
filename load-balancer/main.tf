resource "google_compute_network" "vpc_network" {
  name = "new-terraform-network"
}
resource "google_compute_autoscaler" "foobar" {
  name    = "my-autoscaler"
  project = var.project
  zone    = var.zone
  target  = google_compute_instance_group_manager.foobar.self_link

  autoscaling_policy {
    max_replicas    = 5
    min_replicas    = 2
    cooldown_period = 60

    cpu_utilization {
      target = 0.5
    }
  }
}

resource "google_compute_instance_template" "foobar" {
  name           = "my-instance-template"
  machine_type   = "e2-micro"
  can_ip_forward = false
  project        = var.project
  tags           = ["foo", "bar", "allow-lb-service"]

  disk {
    source_image = data.google_compute_image.centos_7.self_link
  }

  network_interface {
    network = google_compute_network.vpc_network.name
  }

  metadata = {
    foo = "bar"
  }

  service_account {
    scopes = ["userinfo-email", "compute-ro", "storage-ro"]
  }
}

resource "google_compute_target_pool" "foobar" {
  name    = "my-target-pool"
  project = var.project
  region  = var.region
}

resource "google_compute_instance_group_manager" "foobar" {
  name    = "my-igm"
  zone    = var.zone
  project = var.project
  version {
    instance_template = google_compute_instance_template.foobar.self_link
    name              = "primary"
  }

  target_pools       = [google_compute_target_pool.foobar.self_link]
  base_instance_name = "terraform"
}

data "google_compute_image" "centos_7" {
  family  = "centos-7"
  project = "centos-cloud"
}

module "lb" {
  source       = "GoogleCloudPlatform/lb/google"
  version      = "2.2.0"
  region       = var.region
  name         = "load-balancer"
  service_port = 80
  target_tags  = ["my-target-pool"]
  network      = google_compute_network.vpc_network.name
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
# to share a vpc or any other out put between state files, we can use terraform_remote_state data source
# eg:
# 
# data "terraform_remote_state" "vpc" {
#   backend = "gcs"
#   config = {
#     bucket = "mybucket"
#     prefix = "vpc"
#   }
# }

# resource "google_compute_network" "vpc_network" {
#   name = data.terraform_remote_state.vpc.network_name
# }
