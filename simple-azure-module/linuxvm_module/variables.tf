
variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "example-resources"
}

variable "location" {
  description = "Azure region where resources will be created"
  type        = string
  default     = "West Europe"
}

variable "vnet_name" {
  description = "Name of the virtual network"
  type        = string
  default     = "example-network"
}

variable "vnet_address_space" {
  description = "Address space for the virtual network"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "subnet_name" {
  description = "Name of the subnet"
  type        = string
  default     = "internal"
}

variable "subnet_id" {
  description = "ID of the subnet"
  type        = string
}

variable "subnet_address_prefixes" {
  description = "Address prefixes for the subnet"
  type        = list(string)
  default     = ["10.0.2.0/24"]
}


variable "nic_name" {
  description = "Name of the network interface"
  type        = string
  default     = "example-nic"
}

variable "ip_configuration_name" {
  description = "Name of the IP configuration"
  type        = string
  default     = "internal"
}

variable "ip_address_allocation" {
  description = "IP address allocation method"
  type        = string
  default     = "Dynamic"
}

variable "vm_name" {
  description = "Name of the virtual machine"
  type        = string
  default     = "example-machine"
}

variable "vm_size" {
  description = "Size of the virtual machine"
  type        = string
  default     = "Standard_F2"
}

variable "admin_username" {
  description = "Admin username for the virtual machine"
  type        = string
  default     = "adminuser"
}

variable "os_disk_caching" {
  description = "Caching option for the OS disk"
  type        = string
  default     = "ReadWrite"
}

variable "os_disk_storage_account_type" {
  description = "Storage account type for the OS disk"
  type        = string
  default     = "Standard_LRS"
}

variable "image_publisher" {
  description = "Publisher of the VM image"
  type        = string
  default     = "Canonical"
}

variable "image_offer" {
  description = "Offer of the VM image"
  type        = string
  default     = "0001-com-ubuntu-server-jammy"
}

variable "image_sku" {
  description = "SKU of the VM image"
  type        = string
  default     = "22_04-lts"
}

variable "image_version" {
  description = "Version of the VM image"
  type        = string
  default     = "latest"
}

variable "ssh_key_algorithm" {
  description = "Algorithm for SSH key generation"
  type        = string
  default     = "RSA"
}

variable "ssh_key_rsa_bits" {
  description = "Bit size for RSA SSH key"
  type        = number
  default     = 4096
}

variable "private_key_filename" {
  description = "Filename to save the private key"
  type        = string
  default     = "./id_rsa"
}

variable "private_key_file_permission" {
  description = "File permission for the private key file"
  type        = string
  default     = "0600"
}
