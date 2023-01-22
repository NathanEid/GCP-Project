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
  subnet_region = "us-west2"
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
  subnet_region = "us-west2"
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
  vm_name = "my-vm"
  vm_type = "e2-micro"
  vm_zone = "us-west2-a"
  vm_project = "nathan-eid"
  vm_tags = ["private"]
  vm_network = "management-subnet"
  vm_image = "custom-img-nginx"
  depends_on = [
    module.management_subnte
  ]
}

module "allow_ssh" {
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
}