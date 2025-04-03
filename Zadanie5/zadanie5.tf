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
  name = "TerraformTraining-${var.my_das}"
}

data "azurerm_virtual_network" "zadanie2_vn" {
  name                = "${var.my_das}VNET01"
  resource_group_name = data.azurerm_resource_group.zadanie1_group.name
}

data "azurerm_subnet" "subnet2" {
  name                 = "${var.my_das}Subnet02"
  resource_group_name  = data.azurerm_resource_group.zadanie1_group.name
  virtual_network_name = data.azurerm_virtual_network.zadanie2_vn.name
}

resource "azurerm_public_ip" "zadanie5_lb_public_ip" {
  name                = "${var.my_das}LBPublicIP"
  location            = data.azurerm_resource_group.zadanie1_group.location
  resource_group_name = data.azurerm_resource_group.zadanie1_group.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

######<LB_BLOCK>######

resource "azurerm_lb" "zadanie5_lb" {
  name                = "${var.my_das}LB01"
  location            = data.azurerm_resource_group.zadanie1_group.location
  resource_group_name = data.azurerm_resource_group.zadanie1_group.name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = "${var.my_das}LBIPAddress"
    public_ip_address_id = azurerm_public_ip.zadanie5_lb_public_ip.id
  }
}

######</LB_BLOCK>######

######<BACKEND_ADDRESS_POOL_BLOCK>######

resource "azurerm_lb_backend_address_pool" "zadanie5_backend_add_pool" {
  loadbalancer_id = azurerm_lb.zadanie5_lb.id
  name            = "${var.my_das}BPL01"
}

resource "azurerm_lb_probe" "zadanie5_lb_probe" {
  loadbalancer_id     = azurerm_lb.zadanie5_lb.id
  name                = "${var.my_das}LBProbe"
  protocol            = "Tcp"
  port                = var.lb_probe_port
  interval_in_seconds = 15
  number_of_probes    = 2
}

######<LB_RURE_BLOCK>######

resource "azurerm_lb_rule" "zadanie5_lb_rule" {
  loadbalancer_id                = azurerm_lb.zadanie5_lb.id
  name                           = "${var.my_das}LBRule01"
  protocol                       = "Tcp"
  frontend_port                  = var.frontend_port
  backend_port                   = var.backend_port
  frontend_ip_configuration_name = azurerm_lb.zadanie5_lb.frontend_ip_configuration[0].name
  probe_id                       = azurerm_lb_probe.zadanie5_lb_probe.id
}

######</LB_RURE_BLOCK>######

output "load_balancer_id" {
  value = azurerm_lb.zadanie5_lb.id
}