data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "main" {
  name     = "${local.prefix}-${var.ENVIRONMENT}"
  location = var.LOCATION
}