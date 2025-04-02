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

data "azurerm_subnet" "subnet3" {
  name                 = "${var.my_das}Subnet03"
  resource_group_name  = data.azurerm_resource_group.zadanie1_group.name
  virtual_network_name = data.azurerm_virtual_network.zadanie2_vn.name
}

resource "azurerm_network_interface" "fnd" {
  count               = var.vm_count
  name                = "${var.my_das}FNDNIC${count.index + 1}"
  location            = data.azurerm_resource_group.zadanie1_group.location
  resource_group_name = data.azurerm_resource_group.zadanie1_group.name

  ip_configuration {
    name                          = "${var.my_das}ipconfigurationFND${count.index + 1}"
    subnet_id                     = data.azurerm_subnet.subnet2.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface" "dba" {
  name                = "${var.my_das}DBANIC1"
  location            = data.azurerm_resource_group.zadanie1_group.location
  resource_group_name = data.azurerm_resource_group.zadanie1_group.name

  ip_configuration {
    name                          = "${var.my_das}ipconfigurationDBA1"
    subnet_id                     = data.azurerm_subnet.subnet3.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "zadanie4_vm_fnd" {
  count                 = var.vm_count
  name                  = "${var.my_das}VMFND${count.index + 1}"
  location              = data.azurerm_resource_group.zadanie1_group.location
  resource_group_name   = data.azurerm_resource_group.zadanie1_group.name
  network_interface_ids = [azurerm_network_interface.fnd[count.index].id]
  size                  = var.vm_size
  admin_username        = var.admin_username
  admin_password        = var.admin_password

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

resource "azurerm_managed_disk" "d_drive_fnd" {
  count                = var.vm_count
  name                 = "${var.my_das}FRNDD${count.index + 1}"
  location             = data.azurerm_resource_group.zadanie1_group.location
  resource_group_name  = data.azurerm_resource_group.zadanie1_group.name
  storage_account_type = "Standard_LRS"
  disk_size_gb         = var.disk_size_gb_d
  create_option        = "Empty"
}

resource "azurerm_virtual_machine_data_disk_attachment" "example_fnd" {
  count              = var.vm_count
  managed_disk_id    = azurerm_managed_disk.d_drive_fnd[count.index].id
  virtual_machine_id = azurerm_windows_virtual_machine.zadanie4_vm_fnd[count.index].id
  caching            = "ReadWrite"
  lun                = 1
}

resource "azurerm_windows_virtual_machine" "zadanie4_vm_dba" {
  name                  = "${var.my_das}VMDBA1"
  location              = data.azurerm_resource_group.zadanie1_group.location
  resource_group_name   = data.azurerm_resource_group.zadanie1_group.name
  network_interface_ids = [azurerm_network_interface.dba.id]
  size                  = var.vm_size
  admin_username        = var.admin_username
  admin_password        = var.admin_password

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

resource "azurerm_managed_disk" "d_drive_dba" {
  name                 = "${var.my_das}DBAD1"
  location             = data.azurerm_resource_group.zadanie1_group.location
  resource_group_name  = data.azurerm_resource_group.zadanie1_group.name
  storage_account_type = "Standard_LRS"
  disk_size_gb         = var.disk_size_gb_d
  create_option        = "Empty"
}

resource "azurerm_virtual_machine_data_disk_attachment" "example_dba" {
  managed_disk_id    = azurerm_managed_disk.d_drive_dba.id
  virtual_machine_id = azurerm_windows_virtual_machine.zadanie4_vm_dba.id
  caching            = "ReadWrite"
  lun                = 1
}