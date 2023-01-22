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
}

module "restricted_subnet" {
  source = "./subnet"
  subnet_name = "restricted-subnet"
  subnet_cider = "10.0.2.0/24"
  subnet_region = "us-west2"
  subnet_network = module.vpc.vpc_id
  subnet_project = module.vpc.vpc_project
}

module "private_vm" {
  source = "./vm"
  vm_name = "my-vm"
  vm_type = "e2-micro"
  vm_zone = "us-west2-a"
  vm_network = "management-subnet"
  vm_image = "custom-img-nginx"
}