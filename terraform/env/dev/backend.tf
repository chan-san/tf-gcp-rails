terraform {
  required_version = ">= 0.11.0"

  backend "gcs" {
    bucket = "terraform-state--${var.project}"
  }
}
