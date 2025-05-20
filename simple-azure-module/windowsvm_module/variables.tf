variable "vm_size" {
  description = "The size of the virtual machine."
  type        = string
  default     = "Standard_B1s"
}

variable "image_publisher" {
  description = "The publisher of the Windows image."
  type        = string
  default     = "MicrosoftWindowsServer"
}

variable "image_offer" {
  description = "The offer of the Windows image."
  type        = string
  default     = "WindowsServer"
}

variable "image_sku" {
  description = "The SKU of the Windows image."
  type        = string
  default     = "2019-Datacenter"
}

variable "image_version" {
  description = "The version of the Windows image."
  type        = string
  default     = "latest"
}

variable "admin_password" {
  description = "The password for the Windows VM administrator account."
  type        = string
  sensitive   = true
}
