terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
  tags = {
    Environment = var.environment
  }
}

module "network" {
  source              = "./modules/network"
  resource_group_name = azurerm_resource_group.main.name
  location           = azurerm_resource_group.main.location
  vnet_address_space = var.vnet_address_space
  subnet_prefixes    = var.subnet_prefixes
  environment        = var.environment
}

module "container_registry" {
  source              = "./modules/container_registry"
  resource_group_name = azurerm_resource_group.main.name
  location           = azurerm_resource_group.main.location
  acr_name           = var.container_registry_name
  subnet_id          = module.network.shared_subnet_id
  environment        = var.environment
}

module "blob_storage" {
  source              = "./modules/blob_storage"
  resource_group_name = azurerm_resource_group.main.name
  location           = azurerm_resource_group.main.location
  storage_account_name = var.storage_account_name
  container_name      = var.blob_container_name
  subnet_id          = module.network.storage_subnet_id
  environment        = var.environment
}

module "application_insights" {
  source              = "./modules/application_insights"
  resource_group_name = azurerm_resource_group.main.name
  location           = azurerm_resource_group.main.location
  environment        = var.environment
}

module "frontend_app_service" {
  source              = "./modules/frontend_app_service"
  resource_group_name = azurerm_resource_group.main.name
  location           = azurerm_resource_group.main.location
  subnet_id          = module.network.app_subnet_id
  acr_login_server   = module.container_registry.login_server
  docker_image       = var.frontend_docker_image
  app_insights_key   = module.application_insights.instrumentation_key
  environment        = var.environment
}

module "backend_app_service" {
  source              = "./modules/backend_app_service"
  resource_group_name = azurerm_resource_group.main.name
  location           = azurerm_resource_group.main.location
  subnet_id          = module.network.app_subnet_id
  acr_login_server   = module.container_registry.login_server
  docker_image       = var.backend_docker_image
  app_insights_key   = module.application_insights.instrumentation_key
  storage_connection = module.blob_storage.connection_string
  environment        = var.environment
}

module "apim" {
  source              = "./modules/apim"
  resource_group_name = azurerm_resource_group.main.name
  location           = azurerm_resource_group.main.location
  subnet_id          = module.network.shared_subnet_id
  backend_url        = module.backend_app_service.default_site_hostname
  environment        = var.environment
}

module "application_gateway" {
  source               = "./modules/application_gateway"
  resource_group_name  = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  subnet_id           = module.network.gateway_subnet_id
  frontend_url        = module.frontend_app_service.default_site_hostname
  apim_gateway_url    = module.apim.gateway_url
  domain_name         = var.domain_name
  environment         = var.environment
}