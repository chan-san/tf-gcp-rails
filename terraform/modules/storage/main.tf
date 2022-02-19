resource "google_storage_bucket" "assets" {
  name     = "tf-gcp-rails--assets--123456"
  location = var.location
}
