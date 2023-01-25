module "vpc" {
  source = "./vpc"
  vpc_project = "nathan-eid"
  vpc_name = "vpc-network"
  vpc_auto_create_subnet = false
  vpc_mtu = 1460
}

module "management_subnte" {
  source = "./subnet"
  subnet_name = "management-subnet"
  subnet_cider = "10.0.1.0/24"
  subnet_region = "us-west1"
  subnet_network = module.vpc.vpc_id
  subnet_project = module.vpc.vpc_project
  depends_on = [
    module.vpc
  ]
}

module "restricted_subnet" {
  source = "./subnet"
  subnet_name = "restricted-subnet"
  subnet_cider = "10.0.2.0/24"
  subnet_region = "us-west1"
  subnet_network = module.vpc.vpc_id
  subnet_project = module.vpc.vpc_project
  depends_on = [
    module.vpc
  ]
}

module "nat" {
  source = "./nat"
  router_name = "my-router"
  router_region = module.management_subnte.subnet_region
  router_network = module.vpc.vpc_name

  nat_router_name = "gateway-router"
  nat_router_subnetwork_name = module.management_subnte.subnet_name
}

module "private_vm" {
  source = "./vm"
  service_account_id = "managment-cluster"
  service_account_project = module.vpc.vpc_project
  service_account_role = "roles/container.admin"
  vm_name = "my-vm"
  vm_type = "e2-micro"
  vm_zone = "us-west1-b"
  vm_project = "nathan-eid"
  vm_tags = ["private"]
  vm_network = "management-subnet"
  vm_image = "ubuntu-os-cloud/ubuntu-2204-lts" #"custom-img-nginx"
  depends_on = [
    module.management_subnte
  ]
}

module "firewalls" {
  source = "./firewall"
  firewall_name = "allow-ssh"
  firewall_network = module.vpc.vpc_name
  firewall_priority = 1000
  firewall_direction = "INGRESS"
  firewall_project = module.vpc.vpc_project
  firewall_source_ranges = ["35.235.240.0/20"]
  firewall_protocol = "tcp"
  firewall_ports = ["22"]
  firewall_tags = ["private"]

  #################### egress #############

  # firewall_egress_name = "deny"
  # firewall_egress_direction = "EGRESS"
  # firewall_egress_source_ranges = module.restricted_subnet.subnet_cider
  # firewall_egress_protocol = "all"

  depends_on = [
    module.vpc,
    module.restricted_subnet
  ]
}

module "kubernetes_cluster" {
  source = "./kubernetes_cluster"
  depends_on = [
    module.restricted_subnet
  ]
}