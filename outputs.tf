output "resource_group_name" {
  description = "The name of the resource group"
  value       = azurerm_resource_group.main.name
}

output "vnet_id" {
  description = "The ID of the virtual network"
  value       = module.network.vnet_id
}

output "application_gateway_id" {
  description = "The ID of the Application Gateway"
  value       = module.application_gateway.id
}

output "apim_id" {
  description = "The ID of the API Management instance"
  value       = module.apim.id
}

output "app_gateway_public_ip" {
  description = "Public IP address of the Application Gateway"
  value       = module.application_gateway.public_ip
}

output "acr_login_server" {
  description = "Azure Container Registry login server"
  value       = module.container_registry.login_server
}

output "frontend_app_service_url" {
  description = "URL of the frontend App Service"
  value       = module.frontend_app_service.default_site_hostname
}

output "backend_app_service_url" {
  description = "URL of the backend App Service"
  value       = module.backend_app_service.default_site_hostname
}

output "apim_gateway_url" {
  description = "URL of the API Management gateway"
  value       = module.apim.gateway_url
}

output "app_insights_instrumentation_key" {
  description = "Instrumentation key for Application Insights"
  value       = module.application_insights.instrumentation_key
  sensitive   = true
}

output "storage_account_name" {
  description = "Name of the storage account"
  value       = module.blob_storage.storage_account_name
}

output "blob_container_name" {
  description = "Name of the blob container"
  value       = module.blob_storage.container_name
}