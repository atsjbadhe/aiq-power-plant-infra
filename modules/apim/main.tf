resource "azurerm_api_management" "main" {
  name                = "power-plant-apim"
  location            = var.location
  resource_group_name = var.resource_group_name
  publisher_name      = "Power Plant Analytics"
  publisher_email     = "admin@power-plant-analytics.com"
  sku_name           = "Developer_1"

  virtual_network_configuration {
    subnet_id = var.subnet_id
  }

  tags = {
    Environment = var.environment
  }
}

resource "azurerm_api_management_api" "power_plant" {
  name                = "power-plant-api"
  resource_group_name = var.resource_group_name
  api_management_name = azurerm_api_management.main.name
  revision           = "1"
  display_name       = "Power Plant API"
  path               = "api"
  protocols          = ["https"]
  service_url        = "https://${var.backend_url}"

  import_format      = "openapi+json"
  import_content     = jsonencode({
    openapi = "3.1.0"
    info = {
      title       = "Power Plant API"
      description = "API for visualizing power plant net generation data from EPA's eGRID dataset"
      version     = "1.0.0"
    }
    paths = {
      "/power-plants/upload" = {
        post = {
          tags        = ["power-plants"]
          summary     = "Upload Csv"
          description = "Upload a CSV file to S3 bucket"
          operationId = "upload_csv_api_power_plants_upload_post"
          responses   = {
            "200" = {
              description = "Successful Response"
            }
          }
        }
      }
      "/power-plants/states" = {
        get = {
          tags        = ["power-plants"]
          summary     = "Get States"
          description = "Get list of all available states in the dataset"
          operationId = "get_states_api_power_plants_states_get"
          responses   = {
            "200" = {
              description = "Successful Response"
              content = {
                "application/json" = {
                  schema = {
                    type  = "array"
                    items = { type = "string" }
                  }
                }
              }
            }
          }
        }
      }
      "/power-plants" = {
        get = {
          tags        = ["power-plants"]
          summary     = "Get Plants"
          description = "Get top N power plants by net generation for a specific state"
          operationId = "get_plants_api_power_plants__get"
          parameters  = [
            {
              name        = "state"
              in         = "query"
              required   = true
              schema     = {
                type        = "string"
                description = "State abbreviation (e.g., CA, NY)"
              }
            },
            {
              name        = "limit"
              in         = "query"
              required   = false
              schema     = {
                type        = "integer"
                description = "Number of top plants to return"
                default     = 10
              }
            }
          ]
          responses   = {
            "200" = {
              description = "Successful Response"
              content = {
                "application/json" = {
                  schema = {
                    type  = "array"
                    items = {
                      type = "object"
                      properties = {
                        id            = { type = "string" }
                        name          = { type = "string" }
                        state         = { type = "string" }
                        netGeneration = { type = "number" }
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  })
}

resource "azurerm_api_management_product" "power_plant" {
  product_id            = "power-plant"
  api_management_name   = azurerm_api_management.main.name
  resource_group_name   = var.resource_group_name
  display_name          = "Power Plant API"
  subscription_required = true
  published            = true
}

resource "azurerm_api_management_product_api" "power_plant" {
  api_name            = azurerm_api_management_api.power_plant.name
  product_id          = azurerm_api_management_product.power_plant.product_id
  api_management_name = azurerm_api_management.main.name
  resource_group_name = var.resource_group_name
}

output "id" {
  value = azurerm_api_management.main.id
}

output "gateway_url" {
  value = azurerm_api_management.main.gateway_url
}