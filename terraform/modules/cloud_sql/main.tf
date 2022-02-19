resource "google_sql_database_instance" "instance" {
  name = "tf-gcp-rails-private"
  database_version = "MYSQL_5_7"

  settings {
    tier              = "db-f1-micro"
    availability_type = "REGIONAL"
    ip_configuration {
      ipv4_enabled = true
    }
    backup_configuration {
      enabled            = true
      binary_log_enabled = true
    }
  }

  deletion_protection = false
}

// Database

resource "google_sql_database" "database" {
  name     = "app"
  instance = google_sql_database_instance.instance.name

  charset   = "utf8mb4"
  collation = "utf8mb4_bin"
}
