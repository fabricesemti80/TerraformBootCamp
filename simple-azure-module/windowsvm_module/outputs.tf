output "vm_id" {
  description = "ID of the created virtual machine"
  value       = azurerm_linux_virtual_machine.example.id
}

output "vm_private_ip" {
  description = "Private IP address of the virtual machine"
  value       = azurerm_network_interface.example.private_ip_address
}

output "vm_public_ip" {
  description = "Public IP address of the virtual machine"
  value       = azurerm_public_ip.example.ip_address
}

output "ssh_connection_string" {
  description = "SSH connection string to connect to the VM"
  value       = "ssh ${var.admin_username}@${azurerm_public_ip.example.ip_address}"
}

output "connection_info" {
  description = "Information needed to connect to the VM"
  value = {
    username    = var.admin_username
    public_ip   = azurerm_public_ip.example.ip_address
    ssh_command = "ssh ${var.admin_username}@${azurerm_public_ip.example.ip_address}"
  }
}
