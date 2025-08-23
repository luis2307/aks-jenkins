variable "law_name" {
  description = "Nombre Log Analytics workspace"
  type        = string
}
variable "ai_name" {
  description = "Nombre de Application Insights"
  type        = string
}

variable "location" {
  description = "Ubicación de recursos"
  type        = string
}

variable "resource_group_name" {
  description = "Grupo de recursos"
  type        = string
}

variable "tags" {
  description = "Etiquetas comunes"
  type        = map(string)
}
