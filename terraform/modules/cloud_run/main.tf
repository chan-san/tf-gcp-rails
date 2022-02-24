data "google_cloud_run_service" "web" {
  name     = "gcp-rails"
  location = var.location
}

locals {
  image = var.image_sha == "" ? data.google_cloud_run_service.web.template[0].spec[0].containers[0].image : "${var.repository_path}rails@sha256:${var.image_sha}"
}

resource "google_cloud_run_service" "web" {
  name     = "gcp-rails"
  location = var.location
  template {
    spec {
      service_account_name = var.app_account.email
      containers {
        image = local.image
        resources {
          limits = {
            "memory" : var.web_instance.memory,
            "cpu" : var.web_instance.cpu
          }
        }
        env {
          name  = "RAILS_SERVE_STATIC_FILES"
          value = "1"
        }
        env {
          name  = "RAILS_LOG_TO_STDOUT"
          value = "1"
        }
        env {
          name  = "DATABASE_HOST"
          value = var.cloud_sql_private_ip_address
        }
        env {
          name  = "DATABASE_COLLATION"
          value = "utf8mb4_bin"
        }
        env {
          name = "DATABASE_NAME"
          value_from {
            secret_key_ref {
              name = var.secrets.DATABASE_NAME.secret_id
              key  = "latest"
            }
          }
        }
        env {
          name = "DATABASE_USERNAME"
          value_from {
            secret_key_ref {
              name = var.secrets.DATABASE_USERNAME.secret_id
              key  = "latest"
            }
          }
        }
        env {
          name = "DATABASE_PASSWORD"
          value_from {
            secret_key_ref {
              name = var.secrets.DATABASE_PASSWORD.secret_id
              key  = "latest"
            }
          }
        }
      }
    }
    metadata {
      // name = "gcp-rails-v${local.deployment_version}"

      annotations = {
        "autoscaling.knative.dev/maxScale"        = "100"
        "autoscaling.knative.dev/minScale"        = var.web_min_instance
        "run.googleapis.com/vpc-access-connector" = var.cloud_sql_vpc_connector.id
        "run.googleapis.com/vpc-access-egress"    = "private-ranges-only"
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
        resources {
          limits = {
            "memory" : var.worker_instance.memory,
            "cpu" : var.worker_instance.cpu
          }
        }
        env {
          name  = "RAILS_SERVE_STATIC_FILES"
          value = "1"
        }
        env {
          name  = "RAILS_LOG_TO_STDOUT"
          value = "1"
        }
        env {
          name  = "DATABASE_HOST"
          value = var.cloud_sql_private_ip_address
        }
        env {
          name  = "DATABASE_COLLATION"
          value = "utf8mb4_bin"
        }
        env {
          name = "DATABASE_NAME"
          value_from {
            secret_key_ref {
              name = var.secrets.DATABASE_NAME.secret_id
              key  = "latest"
            }
          }
        }
        env {
          name = "DATABASE_USERNAME"
          value_from {
            secret_key_ref {
              name = var.secrets.DATABASE_USERNAME.secret_id
              key  = "latest"
            }
          }
        }
        env {
          name = "DATABASE_PASSWORD"
          value_from {
            secret_key_ref {
              name = var.secrets.DATABASE_PASSWORD.secret_id
              key  = "latest"
            }
          }
        }
      }
    }
    metadata {
      annotations = {
        "autoscaling.knative.dev/maxScale"        = "100"
        "autoscaling.knative.dev/minScale"        = var.worker_min_instance
        "run.googleapis.com/vpc-access-connector" = var.cloud_sql_vpc_connector.id
        "run.googleapis.com/vpc-access-egress"    = "private-ranges-only"
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
  location = google_cloud_run_service.web.location
  project  = google_cloud_run_service.web.project
  service  = google_cloud_run_service.web.name

  policy_data = data.google_iam_policy.noauth.policy_data
}

# CloudRunを実行するためのポリシー
data "google_iam_policy" "invoker" {
  binding {
    role = "roles/run.invoker"
    members = [
      "serviceAccount:${var.run_invoker_account.email}"
    ]
  }
}

resource "google_cloud_run_service_iam_policy" "run_policy" {
  location    = google_cloud_run_service.worker.location
  service     = google_cloud_run_service.worker.name
  policy_data = data.google_iam_policy.invoker.policy_data
}
