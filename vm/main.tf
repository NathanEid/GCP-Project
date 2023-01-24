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

  metadata_startup_script = <<EOF
    sudo apt update -y
    echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
    sudo apt install google-cloud-cli -y

    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    curl -LO "https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
    echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check
    sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
    sudo chmod +x kubectl
    sudo mkdir -p ~/.local/bin
    sudo mv ./kubectl ~/.local/bin/kubectl

    sudo apt install google-cloud-sdk-gke-gcloud-auth-plugin
    echo "Installation Done..." > done.txt
  EOF

  service_account {
    email  = google_service_account.manage_cluster.email
    scopes = ["cloud-platform"]
  }
}