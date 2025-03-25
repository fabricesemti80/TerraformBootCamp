output "resource_group_name" {
  description = "The name of the resource group"
  value       = azurerm_resource_group.example.name
}

output "resource_group_location" {
  description = "The location of the resource group"
  value       = azurerm_resource_group.example.location
}

output "vm_id" {
  description = "The ID of the Virtual Machine"
  value       = azurerm_linux_virtual_machine.example.id
}

output "vm_name" {
  description = "The name of the Virtual Machine"
  value       = azurerm_linux_virtual_machine.example.name
}

output "vm_size" {
  description = "The size of the Virtual Machine"
  value       = azurerm_linux_virtual_machine.example.size
}

output "vm_admin_username" {
  description = "The admin username of the Virtual Machine"
  value       = azurerm_linux_virtual_machine.example.admin_username
}

output "private_ip_address" {
  description = "The primary private IP address of the Virtual Machine"
  value       = azurerm_network_interface.example.ip_configuration[0].private_ip_address
}

output "ssh_private_key_path" {
  description = "Path to the generated SSH private key"
  value       = var.ssh_private_key_path
}

output "ssh_public_key" {
  description = "The generated SSH public key"
  value       = tls_private_key.ssh_key.public_key_openssh
  sensitive   = true
}

output "virtual_network_name" {
  description = "The name of the virtual network"
  value       = azurerm_virtual_network.example.name
}

output "subnet_name" {
  description = "The name of the subnet"
  value       = azurerm_subnet.example.name
}
