output "network_name" {
  value       = google_compute_network.vpc.name
  description = "VPC Network Name"
}

output "network_self_link" {
  value       = google_compute_network.vpc.self_link
  description = "VPC Network Self Link"
}
