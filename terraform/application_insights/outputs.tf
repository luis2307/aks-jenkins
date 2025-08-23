output "instrumentation_key" {
  value = azurerm_application_insights.ai.instrumentation_key
}

output "connection_string" {
  value = azurerm_application_insights.ai.connection_string
}

output "app_insights_name" {
  value = azurerm_application_insights.ai.name
}
output "app_id" {
  value = azurerm_application_insights.ai.app_id
}
output "app_insights_id" {
  value = azurerm_application_insights.ai.id
}

output "log_analytics_workspace_id" {
  value = azurerm_log_analytics_workspace.law.id
}