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

resource "google_storage_bucket_iam_member" "assets" {
  bucket = google_storage_bucket.assets.name
  role   = "roles/storage.legacyObjectReader"
  member = "allUsers"
}

resource "google_storage_bucket_iam_member" "images" {
  bucket = google_storage_bucket.images.name
  role   = "roles/storage.legacyObjectReader"
  member = "allUsers"
}

resource "google_storage_bucket_iam_member" "deployment_account__object_owner" {
  bucket = google_storage_bucket.assets.name
  role   = "roles/storage.legacyObjectOwner"
  member = "serviceAccount:${var.deployment_account.email}"
}

resource "google_storage_bucket_iam_member" "deployment_account__bucket_writer" {
  bucket = google_storage_bucket.assets.name
  role   = "roles/storage.legacyBucketWriter"
  member = "serviceAccount:${var.deployment_account.email}"
}

resource "google_storage_bucket_iam_member" "deployment_account__bucket_reader" {
  bucket = google_storage_bucket.assets.name
  role   = "roles/storage.legacyBucketReader"
  member = "serviceAccount:${var.deployment_account.email}"
}

resource "google_storage_bucket_iam_member" "app_account__object_owner" {
  bucket = google_storage_bucket.images.name
  role   = "roles/storage.legacyObjectOwner"
  member = "serviceAccount:${var.app_account.email}"
}

resource "google_storage_bucket_iam_member" "app_account__bucket_writer" {
  bucket = google_storage_bucket.images.name
  role   = "roles/storage.legacyBucketWriter"
  member = "serviceAccount:${var.app_account.email}"
}

resource "google_storage_bucket_iam_member" "app_account__bucket_reader" {
  bucket = google_storage_bucket.images.name
  role   = "roles/storage.legacyBucketReader"
  member = "serviceAccount:${var.app_account.email}"
}
