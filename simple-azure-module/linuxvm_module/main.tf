terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=2.0.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = ">=4.1.0"
    }
  }
}
provider "azurerm" {
  features {
  }
}

resource "azurerm_network_interface" "example" {
  name                = var.nic_name
  location            = var.location            # this used to be: azurerm_resource_group.example.location
  resource_group_name = var.resource_group_name # this used to be: azurerm_resource_group.example.name

  ip_configuration {
    name                          = var.ip_configuration_name
    subnet_id                     = var.subnet_id # this used to be: azurerm_subnet.example.id
    private_ip_address_allocation = var.ip_address_allocation
  }
}

resource "azurerm_linux_virtual_machine" "example" {
  name                = var.vm_name
  resource_group_name = var.resource_group_name # this used to be: azurerm_resource_group.example.name
  location            = var.location            # this used to be: azurerm_resource_group.example.location
  size                = var.vm_size
  admin_username      = var.admin_username
  network_interface_ids = [
    azurerm_network_interface.example.id,
  ]

  admin_ssh_key {
    username   = var.admin_username
    public_key = tls_private_key.ssh_key.public_key_openssh
  }

  os_disk {
    caching              = var.os_disk_caching
    storage_account_type = var.os_disk_storage_account_type
  }

  source_image_reference {
    publisher = var.image_publisher
    offer     = var.image_offer
    sku       = var.image_sku
    version   = var.image_version
  }
}

resource "tls_private_key" "ssh_key" {
  algorithm = var.ssh_key_algorithm
  rsa_bits  = var.ssh_key_rsa_bits
}

resource "local_file" "private_key" {
  content         = tls_private_key.ssh_key.private_key_pem
  filename        = var.private_key_filename
  file_permission = var.private_key_file_permission
}
