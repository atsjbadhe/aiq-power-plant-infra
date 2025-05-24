resource "azurerm_public_ip" "appgw" {
  name                = "power-plant-appgw-ip"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
  domain_name_label   = replace(var.domain_name, ".", "-")

  tags = {
    Environment = var.environment
  }
}

resource "azurerm_application_gateway" "main" {
  name                = "power-plant-appgw"
  resource_group_name = var.resource_group_name
  location            = var.location

  sku {
    name     = "WAF_v2"
    tier     = "WAF_v2"
    capacity = 2
  }

  gateway_ip_configuration {
    name      = "gateway-ip-config"
    subnet_id = var.subnet_id
  }

  frontend_ip_configuration {
    name                 = "frontend-ip-config"
    public_ip_address_id = azurerm_public_ip.appgw.id
  }

  frontend_port {
    name = "https-port"
    port = 443
  }

  ssl_certificate {
    name     = "ssl-cert"
    data     = filebase64(var.ssl_cert_path)
    password = var.ssl_cert_password
  }

  # Frontend listener and routing
  http_listener {
    name                           = "frontend-https"
    frontend_ip_configuration_name = "frontend-ip-config"
    frontend_port_name            = "https-port"
    protocol                      = "Https"
    ssl_certificate_name          = "ssl-cert"
    host_name                     = var.domain_name
  }

  backend_address_pool {
    name = "frontend-pool"
    fqdns = [var.frontend_url]
  }

  backend_http_settings {
    name                  = "frontend-settings"
    cookie_based_affinity = "Disabled"
    protocol             = "Https"
    port                 = 443
    request_timeout      = 60
    probe_name           = "frontend-probe"
  }

  probe {
    name                = "frontend-probe"
    protocol            = "Https"
    path                = "/"
    interval            = 30
    timeout             = 30
    unhealthy_threshold = 3
    host                = var.frontend_url
    match {
      status_code = ["200-399"]
    }
  }

  # API listener and routing
  http_listener {
    name                           = "api-https"
    frontend_ip_configuration_name = "frontend-ip-config"
    frontend_port_name            = "https-port"
    protocol                      = "Https"
    ssl_certificate_name          = "ssl-cert"
    host_name                     = "api.${var.domain_name}"
  }

  backend_address_pool {
    name = "api-pool"
    fqdns = [var.apim_gateway_url]
  }

  backend_http_settings {
    name                  = "api-settings"
    cookie_based_affinity = "Disabled"
    protocol             = "Https"
    port                 = 443
    request_timeout      = 180
    probe_name           = "api-probe"
  }

  probe {
    name                = "api-probe"
    protocol            = "Https"
    path                = "/status-0123456789abcdef"
    interval            = 30
    timeout             = 30
    unhealthy_threshold = 3
    host                = var.apim_gateway_url
    match {
      status_code = ["200-399"]
    }
  }

  # Routing rules
  request_routing_rule {
    name                       = "frontend-rule"
    rule_type                 = "Basic"
    http_listener_name        = "frontend-https"
    backend_address_pool_name = "frontend-pool"
    backend_http_settings_name = "frontend-settings"
    priority                  = 100
  }

  request_routing_rule {
    name                       = "api-rule"
    rule_type                 = "Basic"
    http_listener_name        = "api-https"
    backend_address_pool_name = "api-pool"
    backend_http_settings_name = "api-settings"
    priority                  = 200
  }

  # WAF Configuration
  waf_configuration {
    enabled          = true
    firewall_mode    = "Prevention"
    rule_set_type    = "OWASP"
    rule_set_version = "3.2"
  }

  tags = {
    Environment = var.environment
  }
}

output "id" {
  value = azurerm_application_gateway.main.id
}

output "public_ip" {
  value = azurerm_public_ip.appgw.ip_address
}