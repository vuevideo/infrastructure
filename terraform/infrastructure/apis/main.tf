resource "google_project_service" "resource_manager" {
  project = var.project_id
  service = "cloudresourcemanager.googleapis.com"

  disable_dependent_services = true
}

resource "google_project_service" "enable_google_apis" {
  count   = length(var.gcp_services_list)
  project = var.project_id
  service = var.gcp_services_list[count.index]

  disable_dependent_services = true
  depends_on                 = [google_project_service.resource_manager]
}
