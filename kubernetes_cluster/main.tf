resource "google_service_account" "kubernetes" {
  account_id   = "kubernetes"
}


resource "google_container_cluster" "primary" {
  name     = "my-gke-cluster"
  location = "europe-west1"

  remove_default_node_pool = true
  initial_node_count       = 1

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
    enable_private_endpoint = false
    master_ipv4_cidr_block  = "172.16.0.0/28"
  }

  ip_allocation_policy {
    cluster_ipv4_cidr_block = "192.168.0.0/16"
    services_ipv4_cidr_block = "10.96.0.0/16" 
  }

  master_authorized_networks_config {
    cidr_blocks {
      display_name = "Management-subnet"
      cidr_block = "10.0.1.0/24"
    }
  }

}

resource "google_container_node_pool" "primary_preemptible_nodes" {
  name       = "my-node-pool"
  location   = "europe-west1"
  cluster    = google_container_cluster.primary.name
  node_count = 1

  node_config {
    preemptible  = true
    machine_type = "e2-micro"
    disk_type = "pd-standard"
    disk_size_gb = 10

    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    service_account = google_service_account.kubernetes.email
    oauth_scopes    = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}



# resource "google_service_account_iam_member" "attach_role_to_sa" {
#   service_account_id = google_service_account.sa.account_id
#   role               = "roles/iam.serviceAccountUser"
#   member             = "serviceAccount:${google_service_account.sa.email}"
# }

# resource "google_container_cluster" "primary" {
#   name                     = "primary"
#   location                 = "us-west2-b"
#   remove_default_node_pool = true
#   initial_node_count       = 1
#   network                  = "vpc-network"
#   subnetwork               = "restricted-subnet"
#   logging_service          = "logging.googleapis.com/kubernetes"
#   monitoring_service       = "monitoring.googleapis.com/kubernetes"
#   networking_mode          = "VPC_NATIVE"

#   addons_config {
#     http_load_balancing {
#       disabled = true
#     }
#     horizontal_pod_autoscaling {
#       disabled = false
#     }
#   }

#   release_channel {
#     channel = "REGULAR"
#   }

#   # workload_identity_config {
#   #   workload_pool = "devops-v4.svc.id.goog"
#   # }

#   # ip_allocation_policy {
#   #   cluster_secondary_range_name  = "pod"
#   #   services_secondary_range_name = "service"
#   # }

#   private_cluster_config {
#     enable_private_nodes    = true
#     enable_private_endpoint = false
#     master_ipv4_cidr_block  = "172.16.0.0/28"
#   }
# }


# # resource "google_service_account" "kubernetes" {
# #   account_id = "kubernetes"
# # }

# # https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_node_pool
# resource "google_container_node_pool" "general" {
#   name       = "general"
#   cluster    = google_container_cluster.primary.id
#   node_count = 1

#   management {
#     auto_repair  = true
#     auto_upgrade = true
#   }

#   node_config {
#     preemptible  = false
#     machine_type = "e2-micro"

#     labels = {
#       role = "general"
#     }

#     service_account = google_service_account.kubernetes.email
#     oauth_scopes = [
#       "https://www.googleapis.com/auth/cloud-platform"
#     ]
#   }
# }

# resource "google_container_node_pool" "spot" {
#   name    = "spot"
#   cluster = google_container_cluster.primary.id

#   management {
#     auto_repair  = true
#     auto_upgrade = true
#   }

#   autoscaling {
#     min_node_count = 0
#     max_node_count = 10
#   }

#   node_config {
#     preemptible  = true
#     machine_type = "e2-micro"

#     labels = {
#       team = "devops"
#     }

#     taint {
#       key    = "instance_type"
#       value  = "spot"
#       effect = "NO_SCHEDULE"
#     }

#     service_account = google_service_account.kubernetes.email
#     oauth_scopes = [
#       "https://www.googleapis.com/auth/cloud-platform"
#     ]
#   }
# }