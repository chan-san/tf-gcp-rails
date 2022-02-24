variable "env" {}
variable "location" {}
variable "repository_path" {}
variable "image_sha" {
  type    = string
  default = ""
}
variable "app_account" {}
variable "cloud_sql_vpc_connector" {}
variable "secrets" {}
variable "cloud_sql_private_ip_address" {}
variable "run_invoker_account" {}
variable "web_min_instance" {
  type    = string
  default = null
}
variable "worker_min_instance" {
  type    = string
  default = null
}
variable "web_instance" {
  type = map(any)
  default = {
    memory = "512Mi"
    cpu    = "1000m"
  }
}
variable "worker_instance" {
  type = map(any)
  default = {
    memory = "512Mi"
    cpu    = "1000m"
  }
}