resource_group_name     = "power-plant-analytics-rg"
location              = "eastus"
environment           = "production"
domain_name           = "power-plant-analytics.com"
vnet_address_space    = "10.0.0.0/16"
container_registry_name = "powerplantacr"
storage_account_name  = "powerplantdata"
blob_container_name   = "powerplantdata"

subnet_prefixes = {
  gateway = "10.0.1.0/24"
  app     = "10.0.2.0/24"
  shared  = "10.0.3.0/24"
  storage = "10.0.4.0/24"
}

# Note: The following sensitive values should be provided via environment variables or a secure vault
# ssl_cert_path = "/path/to/ssl/certificate.pfx"
# ssl_cert_password = "your-certificate-password"