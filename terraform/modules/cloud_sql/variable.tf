variable "env" {}
variable "location" {}
variable "private_vpc_connection" {}
variable "tier" {
  type    = string
  default = "db-f1-micro"
}
variable "service_name" {}
