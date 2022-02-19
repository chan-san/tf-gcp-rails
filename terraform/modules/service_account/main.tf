resource "google_service_account" "deployment_account" {
  provider = google-beta

  account_id   = "deployment-account"
  display_name = "Deployment Service Account"
}

resource "google_service_account" "app_account" {
  provider = google-beta

  account_id   = "app-account"
  display_name = "App Account"
}
