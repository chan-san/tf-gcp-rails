locals {
  image = "${var.repository_path}rails:${var.image_sha}"

  timestamp          = formatdate("YYYYMMDDhhmmss", timestamp())
  deployment_version = var.image_sha == "latest" ? local.timestamp : var.force == "1" ? "${var.image_sha}-${local.timestamp}" : var.image_sha
}

resource "google_cloud_run_service" "app" {
  name     = "gcp-rails"
  location = var.location
  template {
    spec {
      service_account_name = var.app_account.email
      containers {
        image = local.image
        env {
          name  = "RAILS_SERVE_STATIC_FILES"
          value = "1"
        }
        env {
          name  = "RAILS_LOG_TO_STDOUT"
          value = "1"
        }
      }
    }
    metadata {
      // name = "gcp-rails-v${local.deployment_version}"

      annotations = {
        "autoscaling.knative.dev/maxScale" = "100"
        // "autoscaling.knative.dev/minScale" = "4"
      }
    }
  }
  autogenerate_revision_name = true
}

resource "google_cloud_run_service" "worker" {
  name     = "gcp-rails-worker"
  location = var.location
  template {
    spec {
      service_account_name = var.app_account.email
      containers {
        image = local.image
        env {
          name  = "RAILS_LOG_TO_STDOUT"
          value = "1"
        }
      }
    }
    metadata {
      annotations = {
        "autoscaling.knative.dev/maxScale" = "100"
        // "autoscaling.knative.dev/minScale" = "4"
      }
    }
  }
  autogenerate_revision_name = true
}

locals {
  worker_url = google_cloud_run_service.worker.status[0].url
}

data "google_iam_policy" "noauth" {
  binding {
    role = "roles/run.invoker"
    members = [
      "allUsers",
    ]
  }
}

resource "google_cloud_run_service_iam_policy" "noauth" {
  location = google_cloud_run_service.app.location
  project  = google_cloud_run_service.app.project
  service  = google_cloud_run_service.app.name

  policy_data = data.google_iam_policy.noauth.policy_data
}

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
