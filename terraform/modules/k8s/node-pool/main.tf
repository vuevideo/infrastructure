resource "google_container_node_pool" "nodes" {
  name       = var.pool_name
  location   = var.pool_location
  cluster    = var.cluster_name
  node_count = var.pool_count

  max_pods_per_node = 100

  node_locations = var.node_locations

  autoscaling {
    location_policy = "ANY"
    max_node_count  = var.autoscaling_config.max_count
    min_node_count  = var.autoscaling_config.min_count
  }

  node_config {
    preemptible  = var.pool_machine_preemptible
    machine_type = var.pool_machine_type

    disk_size_gb = 10

    workload_metadata_config {
      mode = "GKE_METADATA"
    }

    service_account = var.pool_service_account

    oauth_scopes = [
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/logging.write"
    ]

    dynamic "taint" {
      for_each = var.taints
      content {
        key    = taint.value["key"]
        value  = taint.value["value"]
        effect = taint.value["effect"]
      }
    }

    shielded_instance_config {
      enable_secure_boot          = true
      enable_integrity_monitoring = true
    }

    metadata = {
      google-compute-enable-virtio-rng = "true"
      disable-legacy-endpoints         = "true"
    }
  }
}
