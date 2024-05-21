output "vm_ids" {
  value = azurerm_virtual_machine.vm.*.id
}

output "vm_names" {
  value = ["${azurerm_virtual_machine.vm.*.name}"]
}

output "public_ip" {
  value = azurerm_public_ip.public_ip.ip_address
}