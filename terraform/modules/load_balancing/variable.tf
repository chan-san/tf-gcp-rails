variable "env" {}
variable "location" {}
variable "service_name" {}
variable "project" {}
variable "domain" {}
variable "buckets" {}
variable "cloud_run_apps" {}
variable "use_onetime_cert" {
  type = bool
  default = false
}
