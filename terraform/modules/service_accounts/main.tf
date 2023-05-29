resource "google_service_account" "service_account" {
  account_id   = var.account_id
  display_name = var.display_name
}

resource "google_project_iam_binding" "roles" {
  for_each = toset(var.roles)
  role     = each.key
  members  = ["serviceAccount:${google_service_account.service_account.email}"]
  project  = var.project_id
}
