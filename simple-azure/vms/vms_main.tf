module "vm1" {
  source = "../vm"

  resource_group_name           = "example-resources"
  location                      = "West Europe"
  vnet_name                     = "example-network"
  vnet_address_space            = ["10.0.0.0/16"]
  subnet_name                   = "internal"
  subnet_address_prefixes       = ["10.0.2.0/24"]
  nic_name                      = "vm1-nic"
  private_ip_address_allocation = "Dynamic"
  vm_name                       = "example-machine-1" # Name of the VM
  vm_size                       = "Standard_B1s"      # Cheapest general purpose VM size
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

module "vm2" {
  source = "../vm"

  resource_group_name           = "example-resources"
  location                      = "West Europe"
  vnet_name                     = "example-network"
  vnet_address_space            = ["10.0.0.0/16"]
  subnet_name                   = "internal"
  subnet_address_prefixes       = ["10.0.2.0/24"]
  nic_name                      = "vm2-nic"
  private_ip_address_allocation = "Dynamic"
  vm_name                       = "example-machine-2" # Name of the VM
  vm_size                       = "Standard_B1ls"     # Even cheaper, burstable VM size
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

module "vm3" {
  source = "../vm"

  resource_group_name           = "example-resources"
  location                      = "West Europe"
  vnet_name                     = "example-network"
  vnet_address_space            = ["10.0.0.0/16"]
  subnet_name                   = "internal"
  subnet_address_prefixes       = ["10.0.2.0/24"]
  nic_name                      = "vm3-nic"
  private_ip_address_allocation = "Dynamic"
  vm_name                       = "example-machine-3" # Name of the VM
  vm_size                       = "Standard_A1_v2"    # Another cheap VM size option
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
