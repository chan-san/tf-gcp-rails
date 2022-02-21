resource "google_compute_backend_bucket" "image_backend" {
  name        = var.bucket_name_assets
  description = "Contains beautiful images"
  bucket_name = var.bucket_name_assets
  enable_cdn  = true

  depends_on = [var.compute]
}
