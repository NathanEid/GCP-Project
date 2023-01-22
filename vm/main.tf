resource "google_compute_instance" "vm_instance" {
  name = var.vm_name
  machine_type = var.vm_type
  zone = var.vm_zone
  network_interface {
    #network = var.vm_network
    subnetwork = var.vm_network
  }
  boot_disk {
    initialize_params {
      image = var.vm_image
    }
  }

}