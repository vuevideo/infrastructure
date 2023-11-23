output "node-pool-name" {
  description = "Node Pool Name"
  value       = google_container_node_pool.nodes.name
}
