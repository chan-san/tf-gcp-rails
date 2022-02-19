output "worker_url" {
  value = local.worker_url
}

output "run_account" {
  value = google_service_account.run_invoker.email
}
