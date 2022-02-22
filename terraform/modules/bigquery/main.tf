// Bigquery Proxy
resource "random_password" "pwd" {
  length  = 16
  special = true
}

resource "google_sql_user" "bigquery_user" {
  provider = google-beta
  name     = "bigquery"
  instance = var.cloud_sql.instance.name
  password = random_password.pwd.result
}

resource "google_bigquery_connection" "connection" {
  provider    = google-beta
  location    = var.location
  description = "Cloud SQL Connection"
  cloud_sql {
    instance_id = var.cloud_sql.instance.connection_name
    database    = var.cloud_sql.database.name
    type        = "MYSQL"
    credential {
      username = google_sql_user.bigquery_user.name
      password = google_sql_user.bigquery_user.password
    }
  }
}
