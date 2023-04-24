
resource "google_compute_subnetwork" "private_net" {
  name                     = "private-net"
  ip_cidr_range            = "10.0.0.0/18"
  region                   = var.location
  network                  = google_compute_network.main_vpc.id
  private_ip_google_access = true

  secondary_ip_range {
    range_name    = var.secondary_cluster_range
    ip_cidr_range = "10.48.0.0/14"
  }
  secondary_ip_range {
    range_name    = var.secondary_service_range
    ip_cidr_range = "10.52.0.0/20"
  }
  depends_on = [
    google_compute_network.main_vpc
  ]
}
