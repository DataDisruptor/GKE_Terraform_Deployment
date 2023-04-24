# resource "google_project" "runtime_project" {
#   name       = "My First Project"
#   project_id = var.project_id
#   # billing_account     = var.billing_account
#   # org_id              = var.org_id
#   auto_create_network = false
# }

# resource "google_project_service" "oslogin" {
#   service                    = "oslogin.googleapis.com"
#   disable_dependent_services = false
# }

# resource "google_project_service" "compute" {
#   service                    = "compute.googleapis.com"
#   disable_dependent_services = false
#   depends_on = [
#     google_project_service.oslogin
#   ]
# }

# resource "google_project_service" "container" {
#   service                    = "container.googleapis.com"
#   disable_dependent_services = false

#   depends_on = [
#     google_project_service.compute
#   ]
# }




resource "google_compute_network" "main_vpc" {
  name                            = "my-vpc"
  routing_mode                    = "REGIONAL"
  auto_create_subnetworks         = false
  delete_default_routes_on_create = false
  mtu                             = 1460

  # depends_on = [
  #   google_project_service.compute,
  #   google_project_service.container,
  #   google_project_service.oslogin
  # ]
}
