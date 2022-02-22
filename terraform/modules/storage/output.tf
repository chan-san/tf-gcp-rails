output "buckets" {
  value = {
    assets = google_storage_bucket.assets
    images = google_storage_bucket.images
  }
}
