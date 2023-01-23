resource "google_service_account" "manage_cluster" {
  account_id   = var.service_account_id #"manage-cluster"
}

resource "google_project_iam_member" "gke_management" {
  project = var.service_account_project #"nathan-eid"
  role    = var.service_account_role #"roles/container.admin"
  member  = "serviceAccount:${google_service_account.manage_cluster.email}"
}

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
      type = "pd-standard"
      size = 10
    }
  }

  service_account {
    email  = google_service_account.manage_cluster.email
    scopes = ["cloud-platform"]
  }
}