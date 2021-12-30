locals {
  params = {
    count_up = {
      body = "test"
      cron  = "* * * * *"
    }
  }
}

resource google_cloud_scheduler_job job {
  name             = "test-job-${each.key}"
  description      = "test http job"
  schedule         = each.value.cron
  time_zone        = "Asia/Tokyo"
  attempt_deadline = "320s"
  region           = local.cloud_scheduler_region

  # params分だけリソースを作成する(今回だと3つ)
  for_each = local.params

  retry_config {
    retry_count          = 1
    max_backoff_duration = "3600s"
    max_doublings        = 5
    max_retry_duration   = "0s"
    min_backoff_duration = "5s"
  }

  http_target {
    http_method = "POST"
    uri         = "${local.worker_url}/background_tasks/${each.key}"
    body        = base64encode(jsonencode(each.value))
    headers     = {
      "Content-Type" = "application/json"
    }

    oidc_token {
      audience              = local.worker_url
      service_account_email = google_service_account.run_invoker.email
    }
  }
}