output "cluster_name" {
  description = "K8s Cluster Name"
  value       = google_container_cluster.cluster.name
}

output "cluster_link" {
  description = "K8s Cluster Self Link"
  value       = google_container_cluster.cluster.self_link
}
