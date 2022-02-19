variable "env" {
  type    = string
  default = "dev"
}
variable "project_id" {}
variable "location" {
  type    = string
  default = "asia-northeast1"
}
variable "force" {
  type    = string
  default = ""
}
variable "image_sha" {
  type    = string
  default = "latest"
}

data "google_project" "project" {}
data "google_client_config" "this" {}

locals {
  region  = data.google_client_config.this.region
  project = data.google_client_config.this.project
}
