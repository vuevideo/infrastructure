resource "google_service_account" "service_account" {
  account_id   = var.account_id
  display_name = var.display_name
}

resource "google_service_account_iam_member" "roles" {
  for_each           = toset(var.roles)
  service_account_id = google_service_account.service_account.id
  role               = each.key
  member             = "serviceAccount:${google_service_account.service_account.email}"
}
