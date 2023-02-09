locals {
  prefix = "costa"

  # AKS
  aks_name                   = "${local.prefix}${var.ENVIRONMENT}aks"
  aks_node_resource_group    = "${local.prefix}-aksnodes-${var.ENVIRONMENT}"
  aks_node_resource_group_id = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${local.aks_node_resource_group}"
}
