resource "google_compute_firewall" "firewall_rule" {
  name          = var.firewall_name #"allow-ssh"
  network       = var.firewall_network #"vpc-network"
  priority      = var.firewall_priority #1000
  direction     = var.firewall_direction #"INGRESS"
  project       = var.firewall_project #"nathan-eid"
  source_ranges = var.firewall_source_ranges #["35.235.240.0/20"]

  allow {
    protocol = var.firewall_protocol #"tcp"
    ports    = var.firewall_ports #["22"]
  }

  target_tags = var.firewall_tags #["private"]
}


# resource "google_compute_firewall" "firewall_rule_deny_egress" {
#   project     = var.firewall_project
#   name        = var.firewall_egress_name #"deny"
#   network     = var.firewall_network
#   direction = var.firewall_egress_direction #"EGRESS"
#   source_ranges = [ var.firewall_egress_source_ranges ]

#   deny {
#     protocol  = var.firewall_egress_protocol #"all"
#   }

# }