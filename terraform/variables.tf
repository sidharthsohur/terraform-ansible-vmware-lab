variable "esxi_server" { type = string }
variable "esxi_user" { type = string }
variable "esxi_password" {
  type      = string
  sensitive = true
}
variable "datastore_name" { type = string }
variable "network_name" { type = string }
variable "vm_name" { type = string }