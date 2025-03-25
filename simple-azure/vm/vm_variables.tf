variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region where resources will be created"
  type        = string
}

variable "vnet_name" {
  description = "Name of the virtual network"
  type        = string
}

variable "vnet_address_space" {
  description = "Address space for the virtual network"
  type        = list(string)
}

variable "subnet_name" {
  description = "Name of the subnet"
  type        = string
}

variable "subnet_address_prefixes" {
  description = "Address prefixes for the subnet"
  type        = list(string)
}

variable "nic_name" {
  description = "Name of the network interface"
  type        = string
}

variable "private_ip_address_allocation" {
  description = "IP allocation method for the network interface"
  type        = string
}

variable "vm_name" {
  description = "Name of the virtual machine"
  type        = string
}

variable "vm_size" {
  description = "Size of the virtual machine"
  type        = string
}

variable "admin_username" {
  description = "Admin username for the virtual machine"
  type        = string
}

variable "ssh_key_algorithm" {
  description = "Algorithm for SSH key generation"
  type        = string
}

variable "ssh_key_rsa_bits" {
  description = "RSA bits for SSH key generation"
  type        = number
}

variable "ssh_private_key_path" {
  description = "Path to save the generated SSH private key"
  type        = string
}

variable "os_disk_caching" {
  description = "Caching option for the OS disk"
  type        = string
}

variable "os_disk_storage_account_type" {
  description = "Storage account type for the OS disk"
  type        = string
}

variable "source_image_publisher" {
  description = "Publisher of the VM image"
  type        = string
}

variable "source_image_offer" {
  description = "Offer of the VM image"
  type        = string
}

variable "source_image_sku" {
  description = "SKU of the VM image"
  type        = string
}

variable "source_image_version" {
  description = "Version of the VM image"
  type        = string
}
