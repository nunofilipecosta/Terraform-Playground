resource "azurerm_kubernetes_cluster" "default" {
  name                = local.aks_name
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  dns_prefix          = "${local.prefix}-k8s"
  node_resource_group = local.aks_node_resource_group

  default_node_pool {
    name            = "default"
    os_sku          = "Ubuntu"
    node_count      = 2
    vm_size         = "Standard_B2s"
    os_disk_size_gb = 30
  }

  addon_profile {
    kube_dashboard {
      enabled = false
    }

    # For some reason terraform doesn't recognizes that all underline addons are not enabled and tries to disable them.
    # This causees delays in deployment. In order to mitigate it we explicitly defines them as disabled

    azure_policy {
      enabled = false
    }

    aci_connector_linux {
      enabled = false
    }

    http_application_routing {
      enabled = false
    }

    ingress_application_gateway {
      enabled = false
    }

    oms_agent {
      enabled = false
    }

    open_service_mesh {
      enabled = false
    }
  }

  identity {
    type = "SystemAssigned"
  }

  role_based_access_control {
    enabled = true
  }
}
