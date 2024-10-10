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

resource "azurerm_subnet" "privateNet-subnet" {
  name                 = "privateNet-subnet"
  resource_group_name  = azurerm_resource_group.privateNet-rg.name
  virtual_network_name = azurerm_virtual_network.privateNet-vn.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "vm-privateNet-subnet" {
  name                 = "vm-privateNet-subnet"
  resource_group_name  = azurerm_resource_group.privateNet-rg.name
  virtual_network_name = azurerm_virtual_network.privateNet-vn.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_public_ip" "privateNet-pip" {
  name                = "privateNet-pip"
  location            = var.location
  resource_group_name = azurerm_resource_group.privateNet-rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_network_security_group" "privateNet-sg" {
  name                = "privateNet-sg"
  location            = var.location
  resource_group_name = azurerm_resource_group.privateNet-rg.name

  tags = {
    project = "azure-home-office-solution"
  }
}

resource "azurerm_network_security_rule" "privateNet-dev-rule" {
  name                        = "privateNet-dev-rule"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.privateNet-rg.name
  network_security_group_name = azurerm_network_security_group.privateNet-sg.name
}

resource "azurerm_subnet_network_security_group_association" "privateNet-sga" {
  subnet_id                 = azurerm_subnet.vm-privateNet-subnet.id
  network_security_group_id = azurerm_network_security_group.privateNet-sg.id
}

resource "azurerm_network_interface" "privateNet-nic" {
  name                = "privateNet-nic"
  location            = var.location
  resource_group_name = azurerm_resource_group.privateNet-rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.vm-privateNet-subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.privateNet-pip.id
  }

  tags = {
    project = "azure-home-office-solution"
  }
}

resource "azurerm_linux_virtual_machine" "privateNet-vm" {
  name                = "privateNet-vm"
  resource_group_name = azurerm_resource_group.privateNet-rg.name
  location            = var.location
  size                = "Standard_B2als_v2"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.privateNet-nic.id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  admin_password                  = var.admin_password
  disable_password_authentication = false

  tags = {
    project = "azure-home-office-solution"
  }
}


