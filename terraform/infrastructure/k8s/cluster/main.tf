data "google_compute_network" "k8s-net" {
  name = var.k8s_network_name
}

data "google_compute_subnetwork" "k8s-subnet" {
  name = var.k8s_subnet_name
}

module "gke_cluster" {
  source                        = "../../../modules/k8s/cluster"
  project_id                    = var.project_id
  location                      = var.region
  node_locations                = var.k8s_node_locations
  cluster_name                  = var.cluster_name
  network_name                  = data.google_compute_network.k8s-net.name
  subnet_name                   = data.google_compute_subnetwork.k8s-subnet.name
  control_plane_ipv4_cidr_block = var.control_plane_ipv4_cidr_block
  pods_ipv4_cidr_block          = var.pods_ipv4_cidr_block
  services_ipv4_cidr_block      = var.services_ipv4_cidr_block
}