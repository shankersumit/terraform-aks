# Create Resource Group
resource "azurerm_resource_group" "aksresgrp" {
  name     = var.resource_group
  location = var.location
}

# Create Virtual Network
resource "azurerm_virtual_network" "aksvnet" {
  address_space = ["10.0.0.0/8"]
  location = var.location
  name = var.virtual_network
  resource_group_name = var.resource_group
  depends_on = [
    azurerm_resource_group.aksresgrp
  ]

}

# Create a Subnet for AKS
resource "azurerm_subnet" "aks-default" {
  name                 = var.subnetname
  virtual_network_name = azurerm_virtual_network.aksvnet.name
  resource_group_name  = azurerm_resource_group.aksresgrp.name
  address_prefixes     = ["10.240.0.0/16"]
}


resource "random_uuid" "aksrandom" {

}

resource "random_string" "acrrandom" {
  length = 5
  special = false
}


resource "azurerm_log_analytics_workspace" "insights" {
  name                = "logs-${random_uuid.aksrandom.id}"
  location            = azurerm_resource_group.aksresgrp.location
  resource_group_name = azurerm_resource_group.aksresgrp.name
  retention_in_days   = 30
  depends_on = [
    random_uuid.aksrandom
  ]
}


# resource "azuread_group" "aks_administrators" {
#   display_name = "${azurerm_resource_group.aksresgrp.name}-cluster-administrators"
#   description = "Azure AKS Kubernetes administrators for the ${azurerm_resource_group.aksresgrp.name}-cluster."
#   mail_enabled = false
# }