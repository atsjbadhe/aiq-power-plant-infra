variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region for resources"
  type        = string
}

variable "subnet_id" {
  description = "ID of the subnet to deploy Application Gateway into"
  type        = string
}

variable "frontend_url" {
  description = "URL of the frontend app service"
  type        = string
}

variable "apim_gateway_url" {
  description = "URL of the APIM gateway"
  type        = string
}

variable "domain_name" {
  description = "Custom domain name for the application"
  type        = string
}

variable "ssl_cert_path" {
  description = "Path to the SSL certificate file"
  type        = string
}

variable "ssl_cert_password" {
  description = "Password for the SSL certificate"
  type        = string
  sensitive   = true
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
}