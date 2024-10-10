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