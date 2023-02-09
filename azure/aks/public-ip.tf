resource "azurerm_public_ip" "aks" {
  name                = "${local.prefix}-pip-${var.ENVIRONMENT}"
  location            = azurerm_resource_group.main.location
  resource_group_name = local.aks_node_resource_group
  allocation_method   = "Static"
  sku                 = "Standard"

  domain_name_label = "${local.prefix}${var.ENVIRONMENT}"

  depends_on = [
    azurerm_kubernetes_cluster.default
  ]
}
