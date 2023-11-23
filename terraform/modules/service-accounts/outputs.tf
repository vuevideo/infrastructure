output "service_account_id" {
  description = "ID for the Service Account"
  value       = google_service_account.service_account.account_id
}

output "service_account_email" {
  description = "Email for the service account"
  value       = google_service_account.service_account.email
}
