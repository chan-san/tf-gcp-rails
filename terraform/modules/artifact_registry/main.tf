resource "google_artifact_registry_repository" "app" {
  provider = google-beta

  location      = var.location
  repository_id = "tf-gcp-rails"
  description   = "docker repository with iam"
  format        = "DOCKER"

  // https://console.cloud.google.com/artifacts/settings
  // Turn on Vulnerability-Checking on console.
}

locals {
  app = google_artifact_registry_repository.app
}

resource "google_artifact_registry_repository_iam_member" "deployment-iam" {
  provider = google-beta

  location   = local.app.location
  repository = local.app.name
  role       = "roles/artifactregistry.admin"
  member     = "serviceAccount:${var.deployment_account.email}"
}
