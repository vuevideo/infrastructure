resource "google_container_cluster" "cluster" {
  name     = var.cluster_name
  location = var.location

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

  remove_default_node_pool = true
  initial_node_count       = 1

  # node_config {
  #   disk_size_gb = 10
  # }
}

resource "google_container_node_pool" "nodes" {
  name       = var.pool_name
  location   = var.pool_location
  cluster    = google_container_cluster.cluster.name
  node_count = var.pool_count

  max_pods_per_node = 100

  node_config {
    preemptible  = var.pool_machine_preemptible
    machine_type = var.pool_machine_type

    disk_size_gb = 50

    service_account = var.pool_service_account_email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]

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
