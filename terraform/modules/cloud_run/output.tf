output "worker_url" {
  value = local.worker_url
}

output "apps" {
  value = {
    web    = google_cloud_run_service.web
    worker = google_cloud_run_service.worker
  }
}
