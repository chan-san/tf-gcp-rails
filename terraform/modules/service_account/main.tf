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

resource "google_project_iam_member" "app_account_secretAccessor" {
  project = var.project
  role    = "roles/secretmanager.secretAccessor"
  member  = "serviceAccount:${google_service_account.app_account.email}"
}
// 複数付与する場合
// resource "google_project_iam_member" "app_account_editor" {
//   role    = "roles/editor"
//   member  = "serviceAccount:${google_service_account.app_account.email}"
// }


# CloudRunを実行するサービスアカウント
resource "google_service_account" "run_invoker_account" {
  account_id   = "cloud-run-invoker-sa"
  display_name = "Cloud Run Invoker Service Account"
}
