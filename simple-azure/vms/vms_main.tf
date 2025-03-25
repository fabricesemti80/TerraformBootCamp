module "vm_dev" {
  source = "../vm"

  resource_group_name           = "dev_rg" # Name of the resource group
  location                      = "West Europe"
  vnet_name                     = "dev-network"   # Name of the VNet
  vnet_address_space            = ["10.1.0.0/16"] # Address space of the VNet
  subnet_name                   = "dev-internal"  # Name of the subnet
  subnet_address_prefixes       = ["10.1.2.0/24"] # Address prefix of the subnet
  nic_name                      = "dev-vm-nic"    # Name of the NIC
  private_ip_address_allocation = "Dynamic"
  vm_name                       = "dev-machine"  # Name of the VM
  vm_size                       = "Standard_B1s" # Cheapest general purpose VM size
  admin_username                = "adminuser"
  ssh_key_algorithm             = "RSA"
  ssh_key_rsa_bits              = 4096
  ssh_private_key_path          = "./id_rsa"
  os_disk_caching               = "ReadWrite"
  os_disk_storage_account_type  = "Standard_LRS"
  source_image_publisher        = "Canonical"
  source_image_offer            = "0001-com-ubuntu-server-jammy"
  source_image_sku              = "22_04-lts"
  source_image_version          = "latest"
}

module "vm_stg" {
  source = "../vm"

  resource_group_name           = "stg_rg"
  location                      = "West Europe"
  vnet_name                     = "stg-network"
  vnet_address_space            = ["10.2.0.0/16"]
  subnet_name                   = "stg-internal"
  subnet_address_prefixes       = ["10.2.2.0/24"]
  nic_name                      = "stg-vm-nic"
  private_ip_address_allocation = "Dynamic"
  vm_name                       = "stg-machine"
  vm_size                       = "Standard_B1ls"
  admin_username                = "adminuser"
  ssh_key_algorithm             = "RSA"
  ssh_key_rsa_bits              = 4096
  ssh_private_key_path          = "./id_rsa"
  os_disk_caching               = "ReadWrite"
  os_disk_storage_account_type  = "Standard_LRS"
  source_image_publisher        = "Canonical"
  source_image_offer            = "0001-com-ubuntu-server-jammy"
  source_image_sku              = "22_04-lts"
  source_image_version          = "latest"
}

module "vm_prd" {
  source = "../vm"

  resource_group_name           = "prd_rg"
  location                      = "West Europe"
  vnet_name                     = "prd-network"
  vnet_address_space            = ["10.3.0.0/16"]
  subnet_name                   = "prd-internal"
  subnet_address_prefixes       = ["10.3.2.0/24"]
  nic_name                      = "prd-vm-nic"
  private_ip_address_allocation = "Dynamic"
  vm_name                       = "prd-machine"    # Name of the VM
  vm_size                       = "Standard_A1_v2" # Another cheap VM size option
  admin_username                = "adminuser"
  ssh_key_algorithm             = "RSA"
  ssh_key_rsa_bits              = 4096
  ssh_private_key_path          = "./id_rsa"
  os_disk_caching               = "ReadWrite"
  os_disk_storage_account_type  = "Standard_LRS"
  source_image_publisher        = "Canonical"
  source_image_offer            = "0001-com-ubuntu-server-jammy"
  source_image_sku              = "22_04-lts"
  source_image_version          = "latest"
}
