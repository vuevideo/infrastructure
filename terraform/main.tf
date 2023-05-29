module "k8s_service_account" {
  source       = "./modules/service_accounts"
  account_id   = var.k8s_account_id
  display_name = var.k8s_display_name
  roles        = var.k8s_roles
  project_id   = var.project_id
}

module "k8s_cluster_network" {
  source        = "./modules/k8s/network"
  network_name  = var.k8s_network_name
  subnet_region = var.region
}

module "k8s_cluster" {
  source       = "./modules/k8s/config"
  cluster_name = var.cluster_name
  location     = var.release ? var.region : var.zone
  network_name = module.k8s_cluster_network.network_name
  subnet_name  = module.k8s_cluster_network.subnetwork_name

  control_plane_ipv4_cidr_block = module.k8s_cluster_network.cluster_control_plane_ip_cidr_range
  pods_ipv4_cidr_block          = module.k8s_cluster_network.cluster_pods_ip_cidr_range
  services_ipv4_cidr_block      = module.k8s_cluster_network.cluster_services_ip_cidr_range

  pool_name                  = var.pool_name
  pool_count                 = var.pool_count
  pool_location              = var.release ? var.region : var.zone
  pool_machine_preemptible   = var.pool_machine_preemptible
  pool_machine_type          = var.pool_machine_type
  pool_service_account_email = module.k8s_service_account.service_account_email
}

module "cloud_sql" {
  source                 = "./modules/sql"
  database_availability  = var.database_availability
  database_instance_name = var.database_instance_name
  database_name          = var.database_name
  database_network_link  = module.k8s_cluster_network.network_self_link
  database_password      = var.database_password
  database_tier          = var.database_tier
  database_user          = var.database_user
  database_version       = var.database_version

  depends_on = [module.k8s_cluster]
}
