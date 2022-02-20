terraform {
  required_version = ">= 1.1.6"

  backend "gcs" {
    bucket = "terraform-state--${var.project}"
  }
}
