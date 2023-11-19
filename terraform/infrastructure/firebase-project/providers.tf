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
