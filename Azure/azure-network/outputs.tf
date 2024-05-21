output "network_security_group_id" {
  value = azurerm_network_security_group.nsg.id
}

output "subnet_id_list" {
  value =  azurerm_subnet.sb.id
}

output "virtual_network_id" {
  value = azurerm_virtual_network.vn.id
}

output "virtual_network_name" {
  value = azurerm_virtual_network.vn.name
}

output "public_ip_list" {
  value = azurerm_public_ip.pi.*.ip_address
}

output "public_dns_list" {
  value = azurerm_public_ip.pi.*.fqdn
}



output "public_ip_name_list" {
  value = azurerm_public_ip.pi.*.name
}