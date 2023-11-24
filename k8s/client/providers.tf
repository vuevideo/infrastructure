provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

# Configures the provider to use the resource block's specified project for quota checks.
provider "google-beta" {
  project = var.project_id
  region  = var.region
  zone    = var.zone

  user_project_override = true
}

# Configures the provider to not use the resource block's specified project for quota checks.
# This provider should only be used during project creation and initializing services.
provider "google-beta" {
  alias                 = "no_user_project_override"
  user_project_override = false
}


# Kubernetes Provider Configuration
data "google_client_config" "default" {}

data "google_container_cluster" "gke" {
  name     = var.cluster_name
  location = var.region
}

provider "kubernetes" {
  host                   = "https://${data.google_container_cluster.gke.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(data.google_container_cluster.gke.master_auth[0].cluster_ca_certificate)
}
