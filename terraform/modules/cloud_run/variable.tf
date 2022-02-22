variable "env" {}
variable "location" {}
variable "repository_path" {}
variable "image_sha" {
  type    = string
  default = ""
}
variable "force" {}
variable "app_account" {}
variable "cloud_sql_vpc_connector" {}
variable "secrets" {}
variable "cloud_sql_private_ip_address" {}
variable "run_invoker_account" {}
