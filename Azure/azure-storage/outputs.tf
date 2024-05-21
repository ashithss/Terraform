output "id" {
  value = "${azurerm_resource_group.rg.id}"
}

output "name" {
  value = "${azurerm_resource_group.rg.name}"
}

output "primary_access_key" {
  value = "${azurerm_storage_account.sa.primary_access_key}"
  sensitive = true
}