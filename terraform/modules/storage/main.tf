resource "google_storage_bucket" "assets" {
  name     = "tf-gcp-rails--assets--123456"
  location = var.location
}

resource "google_storage_bucket" "terraform_state" {
  name     = "terraform-state--${var.project}"
  location = var.location
  versioning {
    enabled = true
  }
}
