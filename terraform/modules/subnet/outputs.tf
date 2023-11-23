output "subnetwork_name" {
  value       = google_compute_subnetwork.subnet.name
  description = "VPC Subnet Name"
}

output "subnetwork_link" {
  value       = google_compute_subnetwork.subnet.self_link
  description = "VPC Subnet Link"
}
