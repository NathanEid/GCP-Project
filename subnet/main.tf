resource "google_compute_subnetwork" "subnet" {
  name                     = var.subnet_name
  ip_cidr_range            = var.subnet_cider
  region                   = var.subnet_region
  network                  = var.subnet_network
  project                  = var.subnet_project
  private_ip_google_access = true
}
