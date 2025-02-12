provider "google" {
  project = var.project_id
  region  = var.region
}


resource "google_project_iam_member" "artifact_registry_writer" {
  project = var.project_id
  role    = "roles/artifactregistry.writer"
  member  = "serviceAccount:ganeshreddy7610@gmail.com"  # Ensure correct service account
}

# ✅ Cloud Run Service that deploys the Docker container
resource "google_cloud_run_service" "cloud_run" {
  name     = var.image_name
  location = var.region

  template {
    spec {
      containers {
        image = "${var.region}-docker.pkg.dev/${var.project_id}/my-docker-repo1/${var.image_name}:${var.build_number}"
        
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }

  depends_on = [google_artifact_registry_repository.repo]
}

# ✅ Allow Public Access to Cloud Run
resource "google_cloud_run_service_iam_member" "all_users" {
  service  = google_cloud_run_service.cloud_run.name
  location = google_cloud_run_service.cloud_run.location
  role     = "roles/run.invoker"
  member   = "allUsers"
}

# ✅ Output Cloud Run URL
output "cloud_run_url" {
  value = google_cloud_run_service.cloud_run.status[0].url
}

variable "project_id" {
  default = "mythic-inn-420620"
}

variable "region" {
  default = "us-central1"
}

variable "image_name" {
  default = "docker-cloud"
}



variable "build_number" {
  default = "latest"
}
