output "resource_group_name" {
  value = azurerm_resource_group.main.name
}

output "aks_name" {
  value = azurerm_kubernetes_cluster.default.name
}

output "aks_kubelet_identity_principal_id" {
  value = azurerm_kubernetes_cluster.default.kubelet_identity[0].object_id
}

output "aks_kubelet_identity_resource_id" {
  value = azurerm_kubernetes_cluster.default.kubelet_identity[0].user_assigned_identity_id
}

output "public_ip_aks" {
  value = azurerm_public_ip.aks.ip_address
}