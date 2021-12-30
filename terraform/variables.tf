variable "project_id" {}
variable "github_owner" {}
variable "github_repo" {}
variable "force" {
  type = string
  default = ""
}
variable "image_sha" {
  type = string
  default = "latest"
}
locals {
  timestamp = formatdate("YYYYMMDDhhmmss", timestamp())
  deployment_version = var.image_sha == "latest" ? local.timestamp : var.force == "1" ? "${var.image_sha}-${local.timestamp}" : var.image_sha
}

data "google_client_config" "this" {}

locals {
  region = data.google_client_config.this.region
  project = data.google_client_config.this.project
  // TODO: どこから取ってくる？
  app_engine_location_id = "us-central"
  cloud_scheduler_region = "us-central1"
}
