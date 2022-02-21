resource "google_compute_network" "cloud_sql_private" {
  name = "cloud-sql-private"

  depends_on = [var.compute]
}

resource "google_compute_global_address" "cloud_sql_private_ip_address" {
  name          = "cloud-sql-private-ip-address"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.cloud_sql_private.id
}

resource "google_service_networking_connection" "cloud_sql_private_vpc_connection" {
  network                 = google_compute_network.cloud_sql_private.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.cloud_sql_private_ip_address.name]

  depends_on = [var.servicenetworking]
}

resource "google_vpc_access_connector" "cloud_sql_vpc_connector" {
  name          = "cloud-sql-vpc-connector"
  ip_cidr_range = "10.14.0.0/28"
  network       = google_compute_network.cloud_sql_private.name
}
