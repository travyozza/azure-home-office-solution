terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

resource "azurerm_resource_group" "privateNet-rg" {
  name     = "privateNet-resources"
  location = var.location
  tags = {
    project = "azure-home-office-solution"
  }
}

resource "azurerm_virtual_network" "privateNet-vn" {
  name                = "privateNet-network"
  resource_group_name = azurerm_resource_group.privateNet-rg.name
  location            = var.location
  address_space       = ["10.0.0.0/16"]

  tags = {
    project = "azure-home-office-solution"
  }
}
