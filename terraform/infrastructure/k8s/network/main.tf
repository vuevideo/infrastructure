module "k8s_cluster_network" {
  source       = "../../../modules/network"
  network_name = var.k8s_network_name
}

module "k8s_cluster_subnet" {
  source        = "../../../modules/subnet"
  subnet_name   = var.k8s_subnet_name
  subnet_range  = var.k8s_subnet_range
  subnet_region = var.region
  vpc_name      = module.k8s_cluster_network.network_self_link
}

module "k8s_nat" {
  source      = "../../../modules/nat"
  region      = var.region
  zone        = var.zone
  vpc_name    = module.k8s_cluster_network.network_name
  subnet_name = module.k8s_cluster_subnet.subnetwork_name
}