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