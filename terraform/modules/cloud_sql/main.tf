resource "google_sql_database_instance" "instance" {
  name             = "${var.service_name}-${var.env}"
  database_version = "MYSQL_5_7"

  settings {
    tier              = var.tier
    availability_type = "REGIONAL"
    ip_configuration {
      ipv4_enabled    = true
      private_network = var.private_vpc_connection.network
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
