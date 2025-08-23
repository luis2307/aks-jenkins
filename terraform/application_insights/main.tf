resource "azurerm_log_analytics_workspace" "law" {
  name                = var.law_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = 30


}

resource "azurerm_application_insights" "ai" {
  name                                  = var.ai_name
  location                              = var.location
  resource_group_name                   = var.resource_group_name
  application_type                      = "other"
  retention_in_days                     = 30
  workspace_id                          = azurerm_log_analytics_workspace.law.id
  daily_data_cap_in_gb                  = 1
  daily_data_cap_notifications_disabled = true
  disable_ip_masking                    = false




  tags = var.tags


  depends_on = [azurerm_log_analytics_workspace.law]
}

resource "azurerm_application_insights_smart_detection_rule" "smart_detection_rule" {
  name                               = "Slow server response time"
  application_insights_id            = azurerm_application_insights.ai.id
  enabled                            = false
  send_emails_to_subscription_owners = false

  depends_on = [azurerm_application_insights.ai]

}
 