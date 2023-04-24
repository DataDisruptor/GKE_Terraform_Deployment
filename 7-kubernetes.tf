resource "google_container_cluster" "primary" {
  name                     = var.main_cluster_name
  location                 = var.location
  remove_default_node_pool = true
  initial_node_count       = 1
  network                  = google_compute_network.main_vpc.name
  subnetwork               = google_compute_subnetwork.private_net.name
  networking_mode          = "VPC_NATIVE"

  addons_config {
    http_load_balancing {
      disabled = true
    }
    horizontal_pod_autoscaling {
      disabled = false
    }
  }

  release_channel {
    channel = "REGULAR"
  }

  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }

  ip_allocation_policy {
    cluster_secondary_range_name  = var.secondary_cluster_range
    services_secondary_range_name = var.secondary_service_range
  }

  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = false
    master_ipv4_cidr_block  = "172.16.0.0/28"
  }

  depends_on = [
    google_compute_network.main_vpc,
    google_compute_subnetwork.private_net
  ]
  #   logging_service          = "logging.googleapis.com/kubernetes"
  #   monitoring_service       = "monitoring.googleapis.com/kubernetes"

  # node_locations = [
  #   "${var.location}-b"
  # ]
}
