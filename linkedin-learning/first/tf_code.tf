provider "azurerm" {
  features {

  }
}

resource "azurerm_resource_group" "main" {
  name     = "costa-terraform-first"
  location = "West Europe"
  tags = {
    "environment" = "lab"
  }
}

resource "azurerm_storage_account" "main" {
  name                     = "costaterraformfirstsa"
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  tags = {
    environment = "lab"
  }
}