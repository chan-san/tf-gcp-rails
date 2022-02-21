output "deployment_account" {
  value = google_service_account.deployment_account
}

output "app_account" {
  value = google_service_account.app_account
}

output "run_invoker_account" {
  value = google_service_account.run_invoker_account
}
