output "items" {
  value = {
    DATABASE_NAME = google_secret_manager_secret.DATABASE_NAME
    DATABASE_USERNAME = google_secret_manager_secret.DATABASE_USERNAME
    DATABASE_PASSWORD = google_secret_manager_secret.DATABASE_PASSWORD
  }
}
