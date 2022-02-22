output "instance" {
  value = google_sql_database_instance.instance
}

output "database" {
  value = google_sql_database.database
}

output "resource" {
  value = {
    instance = google_sql_database_instance.instance
    database = google_sql_database.database
  }
}
