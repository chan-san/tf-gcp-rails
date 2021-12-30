# CloudRunを実行するサービスアカウント
resource google_service_account run_invoker {
  account_id   = "cloud-run-invoker-sa"
  display_name = "Cloud Run Invoker Service Account"
}

# シークレットマネージャーの情報を読むための権限
/*
resource google_secret_manager_secret_iam_binding run_invoker {
  secret_id = "sample-secret"
  role      = "roles/secretmanager.secretAccessor"
  members = [
    "serviceAccount:${google_service_account.run_invoker.email}"
  ]
}
*/

# CloudRunを実行するためのポリシー
data google_iam_policy invoker {
  binding {
    role = "roles/run.invoker"
    members = [
      "serviceAccount:${google_service_account.run_invoker.email}"
    ]
  }
}

resource google_cloud_run_service_iam_policy run_policy {
  location    = google_cloud_run_service.worker.location
  service     = google_cloud_run_service.worker.name
  policy_data = data.google_iam_policy.invoker.policy_data
}
