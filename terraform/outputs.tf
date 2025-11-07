output "public_ip_address" {
  description = "O endereço de IP público da máquina virtual."
  value       = azurerm_linux_virtual_machine.vm.public_ip_address
}
