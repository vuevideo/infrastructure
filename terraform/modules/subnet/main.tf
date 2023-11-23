resource "google_compute_subnetwork" "subnet" {
  name                     = var.subnet_name
  ip_cidr_range            = var.subnet_range
  region                   = var.subnet_region
  network                  = var.vpc_name
  private_ip_google_access = true
}
