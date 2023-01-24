output "subnet_name" {
  value = google_compute_subnetwork.subnet.name
}

output "subnet_region" {
  value = google_compute_subnetwork.subnet.region
}

output "subnet_cider" {
  value = google_compute_subnetwork.subnet.ip_cidr_range
}