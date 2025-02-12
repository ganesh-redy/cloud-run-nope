provider "google" {
  project = var.project_id
  region  = var.region
}




# ✅ Cloud Run Service that deploys the Docker container

resource "google_cloud_run_service" "cloud_run" {
  name     = var.image_name
  location = var.region

  template {
    spec {
      containers {
        image = "${var.region}-docker.pkg.dev/${var.project_id}/my-docker-repo1/${var.image_name}:${var.image_tag}"
        
        ports {
          container_port = 8080  # ✅ Ensure this is set!
        }

        
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
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

variable "image_tag" {
  description = "Tag of the Docker image to deploy"
  type        = string
  default     = "latest"  # Optional default value
}


variable "build_number" {
  default = "latest"
}
