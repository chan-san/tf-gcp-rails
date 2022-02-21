variable "env" {
  type    = string
  default = "dev"
}
variable "project_id" {}
variable "service_name" {
  type    = string
  default = ""
}
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
