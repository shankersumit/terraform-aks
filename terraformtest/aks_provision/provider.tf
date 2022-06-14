terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.9.0"
    }
    azuread = {
      source = "hashicorp/azuread"
      version = "~> 2.0"
     }

    random = {
      source = "hashicorp/random"
      version = "~> 3.0"
      
     } 
  }

  backend "azurerm" {
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
    resource_group_name  = "terraform-tfstate-storage"
    storage_account_name = "tfstatestoragebatch5"
  }
}

provider "azurerm" {
  # Configuration options
  features {}
}

