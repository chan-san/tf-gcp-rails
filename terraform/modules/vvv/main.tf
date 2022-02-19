resource "google_service_account" "deployment_account" {
  provider = google-beta

  account_id   = "deployment-account"
  display_name = "Deployment Service Account"
}
