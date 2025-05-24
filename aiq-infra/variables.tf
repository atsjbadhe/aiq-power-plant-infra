variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "eastus"
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
}

variable "vnet_address_space" {
  description = "Address space for Virtual Network"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_prefixes" {
  description = "Map of subnet names to address prefixes"
  type        = map(string)
  default = {
    "gateway" = "10.0.1.0/24"
    "app"     = "10.0.2.0/24"
    "shared"  = "10.0.3.0/24"
    "storage" = "10.0.4.0/24"
  }
}

variable "domain_name" {
  description = "Domain name for the application"
  type        = string
  default     = "power-plant-analytics.com"
}

variable "container_registry_name" {
  description = "Name of the Azure Container Registry"
  type        = string
}

variable "frontend_docker_image" {
  description = "Frontend Docker image name and tag"
  type        = string
  default     = "frontend:latest"
}

variable "backend_docker_image" {
  description = "Backend Docker image name and tag"
  type        = string
  default     = "backend:latest"
}

variable "storage_account_name" {
  description = "Name of the storage account"
  type        = string
}

variable "blob_container_name" {
  description = "Name of the blob container"
  type        = string
  default     = "powerplantdata"
}