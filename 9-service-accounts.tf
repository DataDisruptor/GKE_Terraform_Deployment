# Service Accounts - WorkloadIdentity

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_service_account
resource "google_service_account" "service-a" {
  account_id = "service-a"
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_project_iam
resource "google_project_iam_member" "service-a" {
  project = var.project_id
  role    = "roles/storage.admin" # "roles/resourcemanager.projectCreator" 
  member  = "serviceAccount:${google_service_account.service-a.email}"

  depends_on = [
    google_service_account.service-a
  ]
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_service_account_iam
resource "google_service_account_iam_member" "service-a" {
  service_account_id = google_service_account.service-a.id
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:${var.project_id}.svc.id.goog[staging/service-a]"

  depends_on = [
    google_service_account.service-a
  ]
}

# Further On:
#   Get credentials from cluster:   `$ gcloud container clusters get-credentials ${cluster-name}`
#   Get new k8s context to show:    `$ kubectl config get-contexts`
#   Set new k8s context if needed:  `$ kubectl config use-context ${cluster-id}
#   Make sure GKE plugin installed: `$ gcloud components install gke-gcloud-auth-plugin` - https://cloud.google.com/blog/products/containers-kubernetes/kubectl-auth-changes-in-gke
#   Deploy services:                `$ kubectl apply -f ...`
