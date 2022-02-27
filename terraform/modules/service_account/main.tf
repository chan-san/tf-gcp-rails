resource "google_service_account" "deployment_account" {
  provider = google-beta

  account_id   = "deployment-account"
  display_name = "Deployment Service Account"
}

resource "google_project_iam_custom_role" "service_accounts_act_as" {
  role_id     = "serviceAccountsActAs"
  title       = "serviceAccountsActAs"
  permissions = ["iam.serviceAccounts.actAs"]
}

resource "google_project_iam_member" "deployment_account_runAdmin" {
  project = var.project
  role    = "roles/run.admin"
  member  = "serviceAccount:${google_service_account.deployment_account.email}"
}

resource "google_project_iam_member" "deployment_account_actAs" {
  project = var.project
  role    = google_project_iam_custom_role.service_accounts_act_as.id
  member  = "serviceAccount:${google_service_account.deployment_account.email}"
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

# CloudRunを実行するサービスアカウント
resource "google_service_account" "run_invoker_account" {
  account_id   = "cloud-run-invoker-sa"
  display_name = "Cloud Run Invoker Service Account"
}
