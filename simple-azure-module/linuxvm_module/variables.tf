variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region where resources will be created"
  type        = string
}

variable "nic_name" {
  description = "Name of the network interface"
  type        = string
}

variable "ip_configuration_name" {
  description = "Name of the IP configuration"
  type        = string
  default     = "internal"
}

variable "subnet_id" {
  description = "ID of the subnet where the VM will be connected"
  type        = string
}

variable "ip_address_allocation" {
  description = "Method of private IP allocation"
  type        = string
  default     = "Dynamic"
}

variable "vm_name" {
  description = "Name of the virtual machine"
  type        = string
}

variable "vm_size" {
  description = "Size of the virtual machine"
  type        = string
  default     = "Standard_B1s"
}

variable "admin_username" {
  description = "Username for the VM admin account"
  type        = string
  default     = "adminuser"
}

variable "admin_password" {
  description = "Password for the VM admin account"
  type        = string
  sensitive   = true
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
  default     = "UbuntuServer"
}

variable "image_sku" {
  description = "SKU of the VM image"
  type        = string
  default     = "18.04-LTS"
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
  description = "Number of bits for RSA SSH key"
  type        = number
  default     = 4096
}

variable "private_key_filename" {
  description = "Filename to save the private key"
  type        = string
  default     = "id_rsa"
}

variable "private_key_file_permission" {
  description = "File permission for the private key file"
  type        = string
  default     = "0600"
}

variable "public_ip_name" {
  description = "Name of the public IP address"
  type        = string
  default     = "vm-public-ip"
}

variable "nsg_name" {
  description = "Name of the network security group"
  type        = string
  default     = "vm-nsg"
}

# Add these variables to your existing variables.tf file

variable "public_ip_allocation_method" {
  description = "Allocation method for the public IP address"
  type        = string
  default     = "Static"
}

variable "public_ip_sku" {
  description = "SKU for the public IP address"
  type        = string
  default     = "Standard"
}
