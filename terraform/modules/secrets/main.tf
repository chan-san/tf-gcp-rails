resource "google_secret_manager_secret" "DATABASE_NAME" {
  secret_id = "DATABASE_NAME"

  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret" "DATABASE_USERNAME" {
  secret_id = "DATABASE_USERNAME"

  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret" "DATABASE_PASSWORD" {
  secret_id = "DATABASE_PASSWORD"

  replication {
    automatic = true
  }
}
