variable "aks_name" {
  description = "Nombre del cluster AKS"
  type        = string
}

variable "location" {
  description = "Ubicación del recurso"
  type        = string
}

variable "resource_group_name" {
  description = "Nombre del grupo de recursos"
  type        = string
}

variable "dns_prefix" {
  description = "Prefijo DNS para el cluster"
  type        = string
}

variable "node_pool_name" {
  description = "Nombre del node pool"
  type        = string
  default     = "default"
}

variable "node_count" {
  description = "Número de nodos en el pool"
  type        = number
  default     = 1
}

variable "vm_size" {
  description = "Tamaño de los nodos del pool"
  type        = string
  default     = "Standard_D2_v2"
}

variable "tags" {
  description = "Etiquetas comunes"
  type        = map(string)
  default     = {}
}