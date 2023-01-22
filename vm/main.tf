resource "google_compute_instance" "vm_instance" {
  name = var.vm_name
  machine_type = var.vm_type
  zone = var.vm_zone
  project = var.vm_project
  tags = var.vm_tags

  network_interface {
    subnetwork = var.vm_network
  }

  boot_disk {
    initialize_params {
      image = var.vm_image
    }
  }
}