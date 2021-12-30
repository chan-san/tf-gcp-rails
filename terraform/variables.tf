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
