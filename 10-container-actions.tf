# Clone the Git repository
resource "null_resource" "git_clone" {
  provisioner "local-exec" {
    command = "git clone ${var.git_repo_url}"
  }
}

# Build the Docker image
resource "null_resource" "docker_image_build" {

  provisioner "local-exec" {
    command = "cd app/client && git switch deployment && docker build -t ${var.location}-docker.pkg.dev/${var.project_id}/${var.docker_repo_name}/${var.image_name}:${var.image_tag} ."
  }
  depends_on = [null_resource.git_clone]
}

# Docker Provisions and Resources - INIT

resource "google_artifact_registry_repository" "my-repo" {
  location      = var.location
  repository_id = var.docker_repo_name
  description   = "docker container repo 01"
  format        = "DOCKER"


  depends_on = [
    google_compute_network.main_vpc,
    google_compute_subnetwork.private_net
  ]

}

resource "google_artifact_registry_repository_iam_binding" "binding" {
  project    = google_artifact_registry_repository.my-repo.project
  location   = google_artifact_registry_repository.my-repo.location
  repository = google_artifact_registry_repository.my-repo.name
  role       = "roles/artifactregistry.reader"
  members = [
    "allUsers",
  ]
  depends_on = [
    google_artifact_registry_repository.my-repo
  ]
}

resource "null_resource" "gcloud_docker_auth" {
  depends_on = [
    null_resource.docker_image_build,
    google_compute_network.main_vpc,
    google_artifact_registry_repository.my-repo,
    google_artifact_registry_repository_iam_binding.binding
  ]

  provisioner "local-exec" {
    command = "gcloud auth configure-docker ${var.location}-docker.pkg.dev"
  }
}

resource "null_resource" "docker_push" {
  depends_on = [
    null_resource.gcloud_docker_auth,
    null_resource.docker_image_build,
    google_compute_network.main_vpc,
    google_artifact_registry_repository.my-repo
  ]
  provisioner "local-exec" {
    command = "docker push ${var.location}-docker.pkg.dev/${var.project_id}/${var.docker_repo_name}/${var.image_name}:${var.image_tag}"
  }
}
