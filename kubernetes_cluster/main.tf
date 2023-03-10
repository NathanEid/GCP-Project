resource "google_service_account" "kubernetes" {
  account_id = "kubernetes"
}


resource "google_project_iam_member" "kubernetes_role" {
  project = var.k8s_service_project #"nathan-eid"
  role    = "roles/storage.objectViewer"
  member  = "serviceAccount:${google_service_account.kubernetes.email}"
}


resource "google_container_cluster" "primary" {
  name       = var.k8s_cluster_name       #"my-gke-cluster"
  location   = var.k8s_cluster_location   #"us-west1"
  network    = var.k8s_cluster_network    #"vpc-network"
  subnetwork = var.k8s_cluster_subnetwork #"restricted-subnet"

  remove_default_node_pool = true
  initial_node_count       = var.k8s_cluster_count #1

  addons_config {
    http_load_balancing {
      disabled = true
    }
    horizontal_pod_autoscaling {
      disabled = false
    }
  }

  release_channel {
    channel = "REGULAR"
  }

  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = true
    master_ipv4_cidr_block  = var.k8s_cluster_master_cider #"172.16.0.0/28"
  }

  ip_allocation_policy {
    cluster_ipv4_cidr_block  = var.k8s_cluster_cluster_cider #"192.168.0.0/16"
    services_ipv4_cidr_block = var.k8s_cluster_service_cider #"10.96.0.0/16" 
  }

  master_authorized_networks_config {
    cidr_blocks {
      display_name = "Management-subnet"
      cidr_block   = "10.0.1.0/24"
    }
  }

}

resource "google_container_node_pool" "primary_preemptible_nodes" {
  name       = var.k8s_cluster_node_name
  location   = "us-west1"
  cluster    = google_container_cluster.primary.name
  node_count = 1

  node_config {
    preemptible  = true
    machine_type = "e2-micro"
    disk_type    = "pd-standard"
    disk_size_gb = 10

    service_account = google_service_account.kubernetes.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/servicecontrol",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/trace.append",
    ]
  }
}