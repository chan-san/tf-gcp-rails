resource "google_storage_bucket" "assets" {
  name     = "${var.service_name}-${var.env}-assets"
  location = var.location
}

resource "google_storage_bucket" "images" {
  name     = "${var.service_name}-${var.env}-images"
  location = var.location
}

resource "google_storage_bucket" "terraform_state" {
  name     = "terraform-state--${var.project}"
  location = var.location
  versioning {
    enabled = true
  }
}
