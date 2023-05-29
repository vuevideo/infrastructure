output "network_name" {
  value       = google_compute_network.vpc.name
  description = "VPC Network Name"
}

output "network_self_link" {
  value       = google_compute_network.vpc.self_link
  description = "VPC Network Name"
}

output "subnetwork_name" {
  value       = google_compute_subnetwork.subnet.name
  description = "VPC Subnet Name"
}

output "cluster_control_plane_ip_cidr_range" {
  value       = local.cluster_control_plane_ip_cidr_range
  description = "Cluster Control Plane IP CIDR Range"
}

output "cluster_pods_ip_cidr_range" {
  value       = local.cluster_pods_ip_cidr_range
  description = "Cluster Pods IP CIDR Range"
}

output "cluster_services_ip_cidr_range" {
  value       = local.cluster_services_ip_cidr_range
  description = "Cluster Services IP CIDR Range"
}
