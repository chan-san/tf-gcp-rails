resource "google_cloud_tasks_queue" "advanced_configuration" {
  name     = "background-queue"
  location = var.location

  retry_config {
    max_attempts       = 5
    max_retry_duration = "4s"
    max_backoff        = "3s"
    min_backoff        = "2s"
    max_doublings      = 1
  }

  stackdriver_logging_config {
    sampling_ratio = 0.2
  }
}
