variable "location" {
    default = "East US"
    description = "aks cluster location"
}  

variable "resource_group" {
  default = "terraform-aks"
  description = "resource group name"  
  
}

variable "virtual_network" {
    default = "aksvnet"
    description = "virtual network name"
  }

variable "subnetname" {
    default = "aks-default-subnet"
    description = "virtual network name"
  }

variable "environment" {
    default = "dev"
    description = "environment name"
  
}