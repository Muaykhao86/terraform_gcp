resource "google_compute_instance" "vm" {
  name                    = var.name
  machine_type            = "e2-micro"
  zone                    = "europe-west2-a"
  tags                    = ["web"]
  metadata_startup_script = file("../scripts/startup.sh")

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = "default"
    access_config {
    }
  }
}
