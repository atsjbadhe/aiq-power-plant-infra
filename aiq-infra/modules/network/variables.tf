variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region for resources"
  type        = string
}

variable "vnet_address_space" {
  description = "Address space for Virtual Network"
  type        = string
}

variable "subnet_prefixes" {
  description = "Map of subnet names to address prefixes"
  type        = map(string)
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
}