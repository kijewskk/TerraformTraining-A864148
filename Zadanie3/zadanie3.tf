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

data "azurerm_virtual_network" "zadanie2_vn" {
  name = "A864148VNET01"
  resource_group_name = data.azurerm_resource_group.zadanie1_group.name
}

data "azurerm_subnet" "subnet1" {
  name                 = "A864148Subnet01"
  resource_group_name  = data.azurerm_resource_group.zadanie1_group.name
  virtual_network_name = data.azurerm_virtual_network.zadanie2_vn.name
}

resource "azurerm_public_ip" "zadanie3_pub-ip" {
  name                = "example-public-ip"
  location            = data.azurerm_resource_group.zadanie1_group.location
  resource_group_name = data.azurerm_resource_group.zadanie1_group.name
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "main" {
  name                = "A864148BSTNIC01"
  location            = data.azurerm_resource_group.zadanie1_group.location
  resource_group_name = data.azurerm_resource_group.zadanie1_group.name

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = data.azurerm_subnet.subnet1.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "zadanie3_vm" {
  name                  = "${var.my_das}VMBST01"
  location              = data.azurerm_resource_group.zadanie1_group.location
  resource_group_name   = data.azurerm_resource_group.zadanie1_group.name
  network_interface_ids = [azurerm_network_interface.main.id]
  size               = var.vm_size
  admin_username      = var.admin_username
  admin_password      = var.admin_password

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = var.disk_size_gb_os
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-Datacenter"
    version   = "latest"
  }
}

  resource "azurerm_managed_disk" "d_drive" {
    name                 = "${var.my_das}FNDD1"
    location             = data.azurerm_resource_group.zadanie1_group.location
    resource_group_name  = data.azurerm_resource_group.zadanie1_group.name
    storage_account_type = "Standard_LRS"
    disk_size_gb        = var.disk_size_gb_d 
    create_option        = "Empty"
  }

  resource "azurerm_virtual_machine_data_disk_attachment" "example" {
    managed_disk_id    = azurerm_managed_disk.d_drive.id
    virtual_machine_id = azurerm_windows_virtual_machine.zadanie3_vm.id
    caching            = "ReadWrite"
    lun                = 1 
  }
