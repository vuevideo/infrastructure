data "google_container_cluster" "k8s" {
  name = var.cluster_name
}

module "backend_service_account" {
  source       = "../../../modules/service-accounts"
  project_id   = var.project_id
  account_id   = "vuevideo-backend"
  display_name = "VueVideo Backend Node Pool Service Account"
  roles        = var.backend_pool_roles
}

module "backend_node_pool" {
  source                   = "../../../modules/k8s/node-pool"
  cluster_name             = data.google_container_cluster.k8s.name
  pool_name                = var.backend_pool_name
  pool_location            = var.region
  node_locations           = var.k8s_node_locations
  pool_count               = var.backend_pool_count
  pool_machine_preemptible = var.backend_pool_machine_preemptible
  pool_machine_type        = var.backend_pool_machine_type

  pool_service_account = module.backend_service_account.service_account_email

  taints = [{
    key    = "artifact-type"
    value  = "backend"
    effect = "NO_SCHEDULE"
  }]
}

module "frontend_service_account" {
  source       = "../../../modules/service-accounts"
  project_id   = var.project_id
  account_id   = "vuevideo-frontend"
  display_name = "VueVideo Frontend Node Pool Service Account"
  roles        = var.frontend_pool_roles

  depends_on = [module.backend_node_pool]
}

module "frontend_node_pool" {
  source                   = "../../../modules/k8s/node-pool"
  cluster_name             = data.google_container_cluster.k8s.name
  pool_name                = var.frontend_pool_name
  pool_location            = var.region
  node_locations           = var.k8s_node_locations
  pool_count               = var.frontend_pool_count
  pool_machine_preemptible = var.frontend_pool_machine_preemptible
  pool_machine_type        = var.frontend_pool_machine_type

  pool_service_account = module.frontend_service_account.service_account_email

  taints = [{
    key    = "artifact-type"
    value  = "frontend"
    effect = "NO_SCHEDULE"
  }]
}
