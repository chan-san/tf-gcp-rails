output "cloud_sql_private_vpc_connection" {
  value = google_service_networking_connection.cloud_sql_private_vpc_connection
}
output "cloud_sql_vpc_connector" {
  value = google_vpc_access_connector.cloud_sql_vpc_connector
}
