output "resource" {
  value = {
    instance = google_sql_database_instance.instance
    database = google_sql_database.database
  }
}
