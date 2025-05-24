resource "azurerm_log_analytics_workspace" "main" {
  name                = "power-plant-workspace"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                = "PerGB2018"
  retention_in_days   = 30

  tags = {
    Environment = var.environment
  }
}

resource "azurerm_application_insights" "main" {
  name                = "power-plant-insights"
  location            = var.location
  resource_group_name = var.resource_group_name
  application_type    = "web"
  workspace_id        = azurerm_log_analytics_workspace.main.id

  tags = {
    Environment = var.environment
  }
}

output "instrumentation_key" {
  value     = azurerm_application_insights.main.instrumentation_key
  sensitive = true
}

output "app_id" {
  value = azurerm_application_insights.main.app_id
}

output "connection_string" {
  value     = azurerm_application_insights.main.connection_string
  sensitive = true
}