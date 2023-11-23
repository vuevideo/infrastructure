resource "google_container_cluster" "cluster" {
  name     = var.cluster_name
  location = var.location

  node_locations = var.node_locations

  network    = var.network_name
  subnetwork = var.subnet_name

  ip_allocation_policy {
    cluster_ipv4_cidr_block  = var.pods_ipv4_cidr_block
    services_ipv4_cidr_block = var.services_ipv4_cidr_block
  }

  maintenance_policy {
    daily_maintenance_window {
      start_time = "02:00"
    }
  }

  private_cluster_config {
    # enable_private_endpoint = true
    enable_private_nodes   = true
    master_ipv4_cidr_block = var.control_plane_ipv4_cidr_block
  }

  # master_authorized_networks_config {
  #   cidr_blocks {
  #     cidr_block = "0.0.0.0/0"
  #   }
  # }

  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }

  remove_default_node_pool = true
  initial_node_count       = 1
}
