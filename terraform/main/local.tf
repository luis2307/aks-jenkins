locals {

  company_suffix     = "azlj"
  project_name       = lower("${local.company_suffix}-${var.project}-${var.environment}")
  short_project_name = "${var.project}-${var.environment}"

  resource_group_name = lower("${var.project}-${var.environment}-rg")

  # Tags
  common_tags = {
    # environment       = var.environment
    # project           = var.project
    # owner             = "IT Team"
    # cost_center       = "IT"
    # created_by        = "Terraform"
    # created_date      = formatdate("YYYY-MM-DD", timestamp())
    # last_updated      = formatdate("YYYY-MM-DD", timestamp())
    # last_updated_date = formatdate("YYYY-MM-DD", timestamp())
    # version           = "1.0.0"
    # terraform_version = var.terraform_version
    # provider_version  = var.azurerm_version
    # data_protection   = "GDPR"
    region            = var.location
    environment_type  = var.environment
    # compliance        = "ISO 27001"
  }

  # # Naming
  # sql_server_name      = lower("${local.short_project_name}-sql")
  # sql_db_name          = "${local.short_project_name}-db"
  # vnet_name            = "${local.short_project_name}-vnet"
  # kv_name              = "${local.project_name}-kv"
  # app_service_name     = "${local.project_name}-app"
  # private_dns_zone_sql = "privatelink.database.windows.net"
  # private_dns_zone_kv  = "privatelink.vaultcore.azure.net"
}

