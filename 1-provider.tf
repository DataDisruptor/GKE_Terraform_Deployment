# 1) Create GoogleCloud Project
# 2) Enable Compute Engine API
# 3) Enable Kubernetes Engine
# 4) Create a new Storage Bucket
# 5) Authorize your working terminal - `$ gcloud config set project $PROJECT_ID`

provider "google" {
  project = var.project_id
  region  = var.location
}

terraform {
  backend "gcs" {
    bucket = "staging-env-5005"
    prefix = "state/snapshot/"
  }
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.51.0"
    }
  }
}
