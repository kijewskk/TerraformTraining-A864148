terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.94"
    }
  }
}

provider "azurerm" {
  features {}
}

data "azurerm_resource_group" "zadanie1_group" {
  name = "TerraformTraining-A864148"
}

resource "azurerm_virtual_network" "zadanie2_vn" {
  name                = "A864148VNET01"
  location            = data.azurerm_resource_group.zadanie1_group.location
  resource_group_name = data.azurerm_resource_group.zadanie1_group.name
  address_space       = ["10.0.0.0/16"]

    tags = {
    Owner = "A864148"
  }
}

resource "azurerm_subnet" "subnet1" {
  name                 = "A864148Subnet01"
  resource_group_name  = data.azurerm_resource_group.zadanie1_group.name
  virtual_network_name = azurerm_virtual_network.zadanie2_vn.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "subnet2" {
  name                 = "A864148Subnet02"
  resource_group_name  = data.azurerm_resource_group.zadanie1_group.name
  virtual_network_name = azurerm_virtual_network.zadanie2_vn.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_subnet" "subnet3" {
  name                 = "A864148Subnet03"
  resource_group_name  = data.azurerm_resource_group.zadanie1_group.name
  virtual_network_name = azurerm_virtual_network.zadanie2_vn.name
  address_prefixes     = ["10.0.3.0/24"]
}
