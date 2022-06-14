resource "azurerm_container_registry" "acr" {
  name                = "aksregistry${random_string.acrrandom.id}"
  resource_group_name = azurerm_resource_group.aksresgrp.name
  location            = azurerm_resource_group.aksresgrp.location
  sku                 = "Standard"
  admin_enabled       = false
  identity {
    type = "SystemAssigned"
  }
  depends_on = [
    azurerm_kubernetes_cluster.aks_cluster,
    random_uuid.aksrandom
  ]
}

resource "azurerm_role_assignment" "acrrole" {
  principal_id                     = azurerm_kubernetes_cluster.aks_cluster.kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  scope                            = azurerm_container_registry.acr.id
  skip_service_principal_aad_check = true
  depends_on = [
    azurerm_container_registry.acr
  ]
}