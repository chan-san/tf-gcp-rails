# Resources

## Deployment Account

resource "google_service_account" "deployment-account" {
  provider = google-beta

  account_id   = "deployment-account"
  display_name = "Deployment Service Account"
}

## Artifact Registry

resource "google_artifact_registry_repository" "app" {
  provider     = google-beta

  location = "asia-northeast1"
  repository_id = "tf-gcp-rails"
  description = "docker repository with iam"
  format = "DOCKER"

  // https://console.cloud.google.com/artifacts/settings
  // Turn on Vulnerability-Checking on console.
}

resource "google_artifact_registry_repository_iam_member" "deployment-iam" {
  provider = google-beta

  location = google_artifact_registry_repository.app.location
  repository = google_artifact_registry_repository.app.name
  role   = "roles/artifactregistry.admin"
  member = "serviceAccount:${google_service_account.deployment-account.email}"
}


// Cloud Tasks

resource "google_cloud_tasks_queue" "advanced_configuration" {
  name = "background-queue"
  location = "asia-northeast1"

  retry_config {
    max_attempts = 5
    max_retry_duration = "4s"
    max_backoff = "3s"
    min_backoff = "2s"
    max_doublings = 1
  }

  stackdriver_logging_config {
    sampling_ratio = 0.2
  }

  depends_on = [google_project_service.cloudtasks]
}

// Cloud SQL

resource "google_compute_network" "private_network" {
  name = "private-network"
}

resource "google_compute_global_address" "private_ip_address" {
  name          = "private-ip-address"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.private_network.id
}

resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = google_compute_network.private_network.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_address.name]

  depends_on = [google_project_service.servicenetworking]
}

resource "google_sql_database_instance" "instance" {
  name   = "tf-gcp-rails-private"
  depends_on = [google_service_networking_connection.private_vpc_connection]

  settings {
    tier = "db-f1-micro"
    availability_type = "REGIONAL"
    ip_configuration {
      ipv4_enabled    = true
      private_network = google_compute_network.private_network.id
    }
    backup_configuration {
      enabled = true
      binary_log_enabled = true
    }
  }
}

// Database

resource "google_sql_database" "database" {
  name     = "app"
  instance = google_sql_database_instance.instance.name

  charset          = "utf8mb4"
  collation        = "utf8mb4_bin"
}


// Cloud Run

resource "google_vpc_access_connector" "vpc_connector" {
  name          = "vpc-connector"
  ip_cidr_range = "10.14.0.0/28"
  network       = google_compute_network.private_network.name
}

resource "google_cloud_run_service" "app" {
  name     = "gcp-rails"
  location = "asia-northeast1"
  template {
    // spec {
    //   containers {
    //     image = "asia-northeast1-docker.pkg.dev/rails-test-336417/tf-gcp-rails/app:${var.image_sha}"
    //     env {
    //       name = "RAILS_SERVE_STATIC_FILES"
    //       value = "1"
    //     }
    //     env {
    //       name = "RAILS_LOG_TO_STDOUT"
    //       value = "1"
    //     }
    //   }
    // }
    metadata {
      //name = "gcp-rails-v${local.deployment_version}"
      
      annotations = {
        "autoscaling.knative.dev/maxScale" = "100"
        // "autoscaling.knative.dev/minScale" = "4"
        "run.googleapis.com/vpc-access-connector" = google_vpc_access_connector.vpc_connector.name
        "run.googleapis.com/vpc-access-egress"    = "private-ranges-only"
      }
    }
  }
  // autogenerate_revision_name = true
}

resource "google_cloud_run_service" "worker" {
  name     = "gcp-rails-worker"
  location = "asia-northeast1"
  template {
    // spec {
    //   containers {
    //     image = "asia-northeast1-docker.pkg.dev/rails-test-336417/tf-gcp-rails/app:${var.image_sha}"
    //     env {
    //       name = "RAILS_LOG_TO_STDOUT"
    //       value = "1"
    //     }
    //   }
    // }
    metadata {
      annotations = {
        "autoscaling.knative.dev/maxScale" = "100"
        // "autoscaling.knative.dev/minScale" = "4"
        "run.googleapis.com/vpc-access-connector" = google_vpc_access_connector.vpc_connector.name
        "run.googleapis.com/vpc-access-egress"    = "private-ranges-only"
      }
    }
  }
  // autogenerate_revision_name = true
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
  location    = google_cloud_run_service.app.location
  project     = google_cloud_run_service.app.project
  service     = google_cloud_run_service.app.name

  policy_data = data.google_iam_policy.noauth.policy_data
}

resource "google_storage_bucket" "assets" {
  name          = "tf-gcp-rails--assets"
  location      = "ASIA-NORTHEAST1"
}

resource "google_compute_backend_bucket" "image_backend" {
  name        = "image-backend-bucket"
  description = "Contains beautiful images"
  bucket_name = google_storage_bucket.assets.name
  enable_cdn  = true
}
