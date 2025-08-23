resource "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "Basic"
  admin_enabled       = false
  tags                = var.tags

  identity {
    type = "SystemAssigned"
  }

  # (Opcional) políticas útiles:
  # ACR retention policy can only be applied when using the Premium Sku
  # retention_policy {
  #   days    = 30
  #   enabled = true
  # }
  # georeplications { location = "West Europe" }  # si quieres réplica
  # network_rule_set { default_action = "Deny" }  # si vas a usar Private Link
}
