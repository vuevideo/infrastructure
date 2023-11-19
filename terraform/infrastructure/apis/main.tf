# Enable Cloud Resource Manager API first.
resource "google_project_service" "resource_manager" {
  project = var.project_id
  service = "cloudresourcemanager.googleapis.com"

  disable_dependent_services = true
}

# Enable other APIs
resource "google_project_service" "enable_google_apis" {
  count   = length(var.gcp_services_list)
  project = var.project_id
  service = var.gcp_services_list[count.index]

  disable_dependent_services = true
  depends_on                 = [google_project_service.resource_manager]
  disable_on_destroy         = false
}
