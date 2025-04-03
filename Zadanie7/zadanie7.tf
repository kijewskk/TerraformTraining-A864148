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

# Data block for RG
data "azurerm_resource_group" "zadanie1_group" {
  name = "TerraformTraining-${var.my_das}"
}

# Data block for Bastion NIC
data "azurerm_network_interface" "bastion" {
  name                = var.bastion_nic_name
  resource_group_name = data.azurerm_resource_group.zadanie1_group.name
}

# Data block for Frontend01 NIC
data "azurerm_network_interface" "frontend01" {
  name                = var.front_nic_name1
  resource_group_name = data.azurerm_resource_group.zadanie1_group.name
}

# Data block for Frontend02 NIC
data "azurerm_network_interface" "frontend02" {
  name                = var.front_nic_name2
  resource_group_name = data.azurerm_resource_group.zadanie1_group.name
}

# Data block for DB NIC
data "azurerm_network_interface" "database" {
  name                = var.dba_nic_name
  resource_group_name = data.azurerm_resource_group.zadanie1_group.name
}

#########################################################################################
# Frontend rules

resource "azurerm_network_security_group" "frontend" {
  for_each            = var.frontend_rules
  name                = "inbound_${each.key}"
  location            = data.azurerm_resource_group.zadanie1_group.location
  resource_group_name = data.azurerm_resource_group.zadanie1_group.name
  dynamic "security_rule" {
    for_each = each.value.inbound
    content {
      name                       = security_rule.value.name
      priority                   = security_rule.value.priority
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = security_rule.value.port
      source_address_prefix      = security_rule.value.source
      destination_address_prefix = security_rule.value.destination
    }
  }
}

resource "azurerm_network_interface_security_group_association" "frontend1_nsg" {
  network_interface_id      = data.azurerm_network_interface.frontend01.id
  network_security_group_id = azurerm_network_security_group.frontend["frontend1"].id
  depends_on                = [azurerm_network_security_group.frontend]
}

resource "azurerm_network_interface_security_group_association" "frontend2_nsg" {
  network_interface_id      = data.azurerm_network_interface.frontend02.id
  network_security_group_id = azurerm_network_security_group.frontend["frontend2"].id
  depends_on                = [azurerm_network_security_group.frontend]
}

# Rule for Bastion
resource "azurerm_network_security_group" "bastion" {
  name                = "bastion_inbound"
  location            = data.azurerm_resource_group.zadanie1_group.location
  resource_group_name = data.azurerm_resource_group.zadanie1_group.name

  security_rule {
    name                       = var.BastionRuleName
    priority                   = var.BastionPriority
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = var.BastionPort
    source_address_prefix      = "*"
    destination_address_prefix = var.BastionIP
  }
}

resource "azurerm_network_interface_security_group_association" "bastion_nsg" {
  network_interface_id      = data.azurerm_network_interface.bastion.id
  network_security_group_id = azurerm_network_security_group.bastion.id
}


# Rule for DB
resource "azurerm_network_security_group" "database" {
  name                = "database_inbound"
  location            = data.azurerm_resource_group.zadanie1_group.location
  resource_group_name = data.azurerm_resource_group.zadanie1_group.name

  security_rule {
    name                       = var.DatabaseRuleName
    priority                   = var.DatabasePriority
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = var.DatabasePort
    source_address_prefix      = "*"
    destination_address_prefix = var.DatabaseIP
  }
}

resource "azurerm_network_interface_security_group_association" "database_nsg" {
  network_interface_id      = data.azurerm_network_interface.database.id
  network_security_group_id = azurerm_network_security_group.database.id
}