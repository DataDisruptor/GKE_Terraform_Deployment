# Prerequisites:
#   Enable apis:
#     - Compute Engine
#     - Kubernetes Cluster
#     - Artifact Registry
#     - Cloud Storage ( & create a bucket with name as in `var.bucket_name`)

variable "bucket_name" {
  default = "staging-env-1000"
}

variable "main_cluster_name" {
  default = "core-app-cluster"
}

# Define the Git repository URL
variable "git_repo_url" {
  default = "https://github.com/ceevee-ai/app.git"
}

# Define the Docker image name and tag
variable "image_name" {
  default = "frontend-container"
}

variable "docker_repo_name" {
  default = "my-repo"
}

variable "image_tag" {
  default = "v1"
}

# Define the GCP project ID and zone
variable "project_id" {
  default = "ceevee-ai-v1"
}

variable "project_number" {
  default = ""
}

variable "location" {
  default = "me-west1"
}

variable "zone" {
  default = "me-west1-a"
}

variable "machine_type" {
  default = "e2-medium"
}

variable "gke_num_nodes" {
  default     = 2
  description = "number of gke nodes"
}

variable "secondary_cluster_range" {
  default = "k8s-pod-range"
}
variable "secondary_service_range" {
  default = "k8s-service-range"
}

variable "kube_service_name" {
  default = "kube-service-deployed-00"
}


