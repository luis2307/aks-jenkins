variable "location" {
  type = string
}

variable "project" {
  type = string
}

variable "environment" {
  type = string
}
variable "terraform_version" {
  type    = string
  default = "v1.11.3"
}

variable "azurerm_version" {
  type    = string
  default = "3.0"
}

variable "kubernetes_version" {
  type    = string
  default = null
}
variable "dns_prefix" {
  type    = string
  default = "devaks"
}

variable "aad_admin_group_object_ids" {
  type    = list(string)
  default = []
}

variable "system_vm_size" {
  type    = string
  default = "Standard_D4s_v5"
}
variable "system_min" {
  type    = number
  default = 1
}
variable "system_max" {
  type    = number
  default = 3
}
