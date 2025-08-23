data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "app" {
  name     = local.resource_group_name
  location = var.location
}

module "acr" {
  source              = "../acr"
  acr_name            = "${replace(local.short_project_name, "-", "")}acr"
  location            = var.location
  resource_group_name = local.resource_group_name
  tags                = local.common_tags

  depends_on = [azurerm_resource_group.app]
}
module "aks" {
  source              = "../aks"
  aks_name            = "${local.short_project_name}-aks"
  location            = var.location
  resource_group_name = local.resource_group_name
  dns_prefix          = "devaks"
  node_count          = 1
  node_pool_name      = "default"
  vm_size             = "Standard_D2_v2"
  tags                = local.common_tags

  depends_on = [azurerm_resource_group.app, module.acr]
}


data "azurerm_kubernetes_cluster" "aks" {
  name                = module.aks.aks_name
  resource_group_name = local.resource_group_name
  depends_on          = [module.aks]
}

resource "azurerm_role_assignment" "aks_acr_pull" {
  principal_id         = data.azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
  role_definition_name = "AcrPull"
  scope                = module.acr.acr_id

  depends_on = [ azurerm_resource_group.app, module.acr, module.aks ]
}