
####################################################-> Container Names & Tags Config <-##############################################################
# Frontend --------------------------------- #
variable "frontend_image_name" {
  default = "frontend-container"
}

variable "frontend_image_tag" {
  default = "v1"
}

# Auth --------------------------------- #
variable "auth_image_name" {
  default = "auth-container"
}

variable "auth_image_tag" {
  default = "v1"
}

# Chat --------------------------------- #
variable "chat_image_name" {
  default = "chat-container"
}

variable "chat_image_tag" {
  default = "v1"
}

# Resume --------------------------------- #
variable "resume_image_name" {
  default = "resume-container"
}

variable "resume_image_tag" {
  default = "v1"
}

# Gateway --------------------------------- #
variable "gateway_image_name" {
  default = "gateway-container"
}

variable "gateway_image_tag" {
  default = "v1"
}

####################################################-> Github Config <-##############################################################

# Define the Git repository URL
variable "git_repo_url" {
  default = "https://github.com/ceevee-ai/app.git"
}

# Git branch. change to "main" in production
variable "git_branch" {
  default = "deployment"
}

# Git clone folder name
variable "git_repo_main_dir" {
  default = "app"
}

# Frontend service
variable "git_repo_frontend_dir" {
  default = "/client"
}

# Auth service
variable "git_repo_auth_dir" {
  default = "/services/auth"
}

# Chat service
variable "git_repo_chat_dir" {
  default = "/services/chat"
}

# Resume service
variable "git_repo_resume_dir" {
  default = "/services/resume"
}

# Gateway service
variable "git_repo_gateway_dir" {
  default = "/services/gateway"
}

####################################################-> Cloud Config <-##############################################################

# Storage bucket name (UNUSED, set "bucket" at `1-provider.tf` instead)
variable "bucket_name" {
  default = "staging-env-5005"
}

variable "main_cluster_name" {
  default = "core-app-cluster"
}

variable "docker_repo_name" {
  default = "my-repo"
}

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

####################################################-> Deployment Config <-##############################################################

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

variable "helm_ingress_version" {
  default = "4.6.0"
}
