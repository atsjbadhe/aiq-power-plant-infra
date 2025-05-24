resource "azurerm_service_plan" "frontend" {
  name                = "frontend-app-plan"
  location            = var.location
  resource_group_name = var.resource_group_name
  os_type             = "Linux"
  sku_name            = "P1v2"

  tags = {
    Environment = var.environment
  }
}

resource "azurerm_linux_web_app" "frontend" {
  name                = "power-plant-frontend"
  location            = var.location
  resource_group_name = var.resource_group_name
  service_plan_id     = azurerm_service_plan.frontend.id
  https_only          = true

  site_config {
    always_on          = true
    application_stack {
      docker_image     = "${var.acr_login_server}/${var.docker_image}"
      docker_image_tag = "latest"
    }
  }

  virtual_network_subnet_id = var.subnet_id

  app_settings = {
    "APPINSIGHTS_INSTRUMENTATIONKEY"        = var.app_insights_key
    "APPLICATIONINSIGHTS_CONNECTION_STRING" = var.app_insights_connection_string
    "DOCKER_REGISTRY_SERVER_URL"           = "https://${var.acr_login_server}"
    "DOCKER_REGISTRY_SERVER_USERNAME"      = var.acr_admin_username
    "DOCKER_REGISTRY_SERVER_PASSWORD"      = var.acr_admin_password
    "WEBSITES_PORT"                        = "80"
  }

  tags = {
    Environment = var.environment
  }
}

output "id" {
  value = azurerm_linux_web_app.frontend.id
}

output "default_site_hostname" {
  value = azurerm_linux_web_app.frontend.default_hostname
}