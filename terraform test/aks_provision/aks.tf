resource "azurerm_kubernetes_cluster" "aks_cluster" {
  name                = "${azurerm_resource_group.aksresgrp.name}-cluster"
  location            = azurerm_resource_group.aksresgrp.location
  resource_group_name = azurerm_resource_group.aksresgrp.name
  dns_prefix          = "${azurerm_resource_group.aksresgrp.name}-cluster"
  kubernetes_version  = data.azurerm_kubernetes_service_versions.current.latest_version
  node_resource_group = "${azurerm_resource_group.aksresgrp.name}-nrg"

  default_node_pool {
    name                 = "systempool"
    vm_size              = "Standard_DS2_v2"
    orchestrator_version = data.azurerm_kubernetes_service_versions.current.latest_version
    enable_auto_scaling  = true
    max_count            = 3
    min_count            = 1
    os_disk_size_gb      = 30
    type                 = "VirtualMachineScaleSets"
    vnet_subnet_id        = azurerm_subnet.aks-default.id 
    node_labels = {
      "nodepool-type"    = "system"
      "environment"      = "dev"
      "nodepoolos"       = "linux"
      "app"              = "system-apps" 
    } 
   tags = {
      "nodepool-type"    = "system"
      "environment"      = "dev"
      "nodepoolos"       = "linux"
      "app"              = "system-apps" 
   } 
  }

# Identity (System Assigned or Service Principal)
  identity {
    type = "SystemAssigned"
  }


 azure_policy_enabled = true

 oms_agent {
   log_analytics_workspace_id = azurerm_log_analytics_workspace.insights.id
 }

role_based_access_control_enabled = true
azure_active_directory_role_based_access_control {
  managed = true
  #admin_group_object_ids = [azuread_group.aks_administrators.id]
}


# # Windows Profile
#   windows_profile {
#     admin_username = var.windows_admin_username
#     admin_password = var.windows_admin_password
#   }

# # Linux Profile
#   linux_profile {
#     admin_username = "ubuntu"
#     ssh_key {
#       key_data = file(var.ssh_public_key)
#     }
#   }

# Network Profile
  network_profile {
    network_plugin = "azure"
    load_balancer_sku = "standard"
    
  }

  tags = {
    Environment = "dev"
  }
}


resource "azurerm_kubernetes_cluster_node_pool" "linux101" {
  enable_auto_scaling   = true
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks_cluster.id
  max_count             = 3
  min_count             = 1
  mode                  = "User"
  name                  = "linux101"
  orchestrator_version  = data.azurerm_kubernetes_service_versions.current.latest_version
  os_disk_size_gb       = 30
  os_type               = "Linux" # Default is Linux, we can change to Windows
  vm_size               = "Standard_DS2_v2"
  priority              = "Regular"  # Default is Regular, we can change to Spot with additional settings like eviction_policy, spot_max_price, node_labels and node_taints
  vnet_subnet_id        = azurerm_subnet.aks-default.id   
  node_labels = {
    "nodepool-type" = "user"
    "environment"   = var.environment
    "nodepoolos"    = "linux"
    "app"           = "java-apps"
  }
  tags = {
    "nodepool-type" = "user"
    "environment"   = var.environment
    "nodepoolos"    = "linux"
    "app"           = "java-apps"
  }
}