output "resource_group_name" {
  value = local.resource_group_name
}
  
output "acr_login_server" {
  value = module.acr.acr_login_server
}

output "acr_admin_username" {
  value = module.acr.acr_admin_username
}

output "acr_admin_password" {
  value     = module.acr.acr_admin_password
  sensitive = true
}
  

output "acr_id" {
  value = module.acr.acr_id
}
output "aks_name" {
  value = module.aks.aks_name
}
output "aks_id" {
  value = module.aks.aks_id
}
output "kube_config" {
  value     = module.aks.kube_config
  sensitive = true
}
output "client_certificate" {
  value     = module.aks.client_certificate
  sensitive = true
}
 