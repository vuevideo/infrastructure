resource "google_compute_global_address" "private_ip_address" {
  name          = "private-ip-address"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = var.database_network_link
}

resource "google_service_networking_connection" "default" {
  network                 = var.database_network_link
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_address.name]
}

resource "google_sql_database" "database" {
  name     = var.database_name
  instance = google_sql_database_instance.primary_instance.name
}

resource "google_sql_database_instance" "primary_instance" {
  name             = var.database_instance_name
  database_version = var.database_version

  deletion_protection = false

  settings {
    tier              = var.database_tier
    availability_type = var.database_availability

    disk_size = 50

    ip_configuration {
      ipv4_enabled    = false
      private_network = var.database_network_link
    }
  }

  depends_on = [google_service_networking_connection.default]
}
resource "google_sql_user" "database_user" {
  name     = var.database_user
  instance = google_sql_database_instance.primary_instance.name
  password = var.database_password
}
