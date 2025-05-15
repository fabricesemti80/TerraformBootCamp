/* -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- */
/*                                                                                       Provider configuration                                                                                       */
/* -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- */
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

/* -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- */
/*                                                                          Resources created OUTSIDE [before] of the module                                                                          */
/* -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- */
resource "azurerm_resource_group" "example" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_virtual_network" "example" {
  name                = var.vnet_name
  address_space       = var.vnet_address_space
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_subnet" "example" {
  name                 = var.subnet_name
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = var.subnet_address_prefixes
}

/* -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- */
/*                                                                                            Module calls                                                                                            */
/* -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- */
module "vm_example_1" {
  source = "./linuxvm_module"

  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  subnet_id           = azurerm_subnet.example.id

  vm_name              = "vm-example-1"
  nic_name             = "nic-example-1"
  private_key_filename = "./id_rsa_example_1"

  image_offer = "0001-com-ubuntu-server-jammy"
  image_sku   = "22_04-lts"
}

module "vm_example_2" {
  source = "./linuxvm_module"

  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  subnet_id           = azurerm_subnet.example.id

  vm_name              = "vm-example-2"
  nic_name             = "nic-example-2"
  private_key_filename = "./id_rsa_example_2"

  image_offer = "ubuntu-24_04-lts"
  image_sku   = "server"
  vm_size     = "Standard_D2s_v3"

}

