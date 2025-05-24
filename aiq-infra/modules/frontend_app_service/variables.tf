variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region for resources"
  type        = string
}

variable "subnet_id" {
  description = "ID of the subnet to deploy App Service into"
  type        = string
}

variable "acr_login_server" {
  description = "Login server URL for Azure Container Registry"
  type        = string
}

variable "docker_image" {
  description = "Docker image name for the frontend application"
  type        = string
}

variable "acr_admin_username" {
  description = "Admin username for Azure Container Registry"
  type        = string
}

variable "acr_admin_password" {
  description = "Admin password for Azure Container Registry"
  type        = string
  sensitive   = true
}

variable "app_insights_key" {
  description = "Instrumentation key for Application Insights"
  type        = string
  sensitive   = true
}

variable "app_insights_connection_string" {
  description = "Connection string for Application Insights"
  type        = string
  sensitive   = true
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
}