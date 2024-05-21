output "tenant_id" {
  value = data.azuread_client_config.main.tenant_id
}

output "display_name" {
  value = azuread_application.example.display_name
}