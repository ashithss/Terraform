output "cdn_endpoint_id" {
  value = "${azurerm_cdn_endpoint.example.name}.azureedge.net"
}