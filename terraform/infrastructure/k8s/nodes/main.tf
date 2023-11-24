data "google_container_cluster" "k8s" {
  name = var.cluster_name
}

module "backend_service_account" {
  source       = "../../../modules/service-accounts"
  project_id   = var.project_id
  account_id   = var.backend_iam_name
  display_name = "VueVideo Backend Node Pool Service Account"
  roles        = var.backend_pool_roles
}

resource "google_service_account_iam_binding" "backend-cicd-account-iam" {
  service_account_id = module.backend_service_account.service_account_id
  role               = "roles/iam.serviceAccountUser"

  members = [
    "serviceAccount:${var.ci_cd_email}",
  ]
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

  k8s_labels = {
    "vuevideo/artifact-type" = "backend"
  }

  depends_on = [google_service_account_iam_binding.backend-cicd-account-iam]
}

module "frontend_service_account" {
  source       = "../../../modules/service-accounts"
  project_id   = var.project_id
  account_id   = var.frontend_iam_name
  display_name = "VueVideo Frontend Node Pool Service Account"
  roles        = var.frontend_pool_roles

  depends_on = [module.backend_node_pool]
}

resource "google_service_account_iam_binding" "frontend-cicd-account-iam" {
  service_account_id = module.frontend_service_account.service_account_id
  role               = "roles/iam.serviceAccountUser"

  members = [
    "serviceAccount:${var.ci_cd_email}",
  ]
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

  k8s_labels = {
    "vuevideo/artifact-type" = "frontend"
  }

  depends_on = [google_service_account_iam_binding.frontend-cicd-account-iam]
}
