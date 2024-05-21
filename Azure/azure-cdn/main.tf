#Resource block to create the azure resource group
resource "azurerm_resource_group" "example" {
  name     = "${var.prefix}-resources" #(Required) The Name which should be used for this Resource Group. 
  location = "${var.location}" #(Required) The Azure Region where the Resource Group should exist. 
}
#Manages an Azure Storage Account.
resource "azurerm_storage_account" "stor" {
  name                     = "${var.prefix}stor" #(Required) Specifies the name of the storage account. Only lowercase Alphanumeric characters allowed. Changing this forces a new resource to be created. This must be unique across the entire Azure service, not just within the resource group.
  location                 = "${azurerm_resource_group.example.location}"# (Required) Specifies the supported Azure location where the resource exists. 
  resource_group_name      = "${azurerm_resource_group.example.name}" #(Required) The name of the resource group in which to create the storage account. Changing this forces a new resource to be created.
  account_tier             = "Standard" #(Required) Defines the Tier to use for this storage account. Valid options are Standard and Premium. For BlockBlobStorage and FileStorage accounts only Premium is valid. Changing this forces a new resource to be created.
  account_replication_type = "LRS" #(Required) Defines the type of replication to use for this storage account. Valid options are LRS, GRS, RAGRS, ZRS, GZRS and RAGZRS.
}
#Manages a CDN Profile to create a collection of CDN Endpoints.
resource "azurerm_cdn_profile" "example" {
  name                = "${var.prefix}-cdn" #(Required) Specifies the name of the CDN Profile.
  location            = "${azurerm_resource_group.example.location}" # (Required) Specifies the supported Azure location where the resource exists.
  resource_group_name = "${azurerm_resource_group.example.name}" #(Required) The name of the resource group in which to create the CDN Profile.
  sku                 = "Standard_Akamai" #(Required) The pricing related information of current CDN profile. Accepted values are Standard_Akamai, Standard_ChinaCdn, Standard_Microsoft, Standard_Verizon or Premium_Verizon. Changing this forces a new resource to be created.
}
#A CDN Endpoint is the entity within a CDN Profile containing configuration information regarding caching behaviours and origins. The CDN Endpoint is exposed using the URL format <endpointname>.azureedge.net.
resource "azurerm_cdn_endpoint" "example" {
  name                = "${var.prefix}-cdn" #(Required) Specifies the name of the CDN Endpoint.
  profile_name        = "${azurerm_cdn_profile.example.name}" # (Required) The CDN Profile to which to attach the CDN Endpoint. 
  location            = "${azurerm_resource_group.example.location}" #(Required) Specifies the supported Azure location where the resource exists.
  resource_group_name = "${azurerm_resource_group.example.name}" #(Required) The name of the resource group in which to create the CDN Endpoint.

  origin {
    name       = "${var.prefix}origin1" #(Required) The name of the origin. This is an arbitrary value. However, this value needs to be unique under the endpoint.
    host_name  = "www.contoso.com" # (Required) A string that determines the hostname/IP address of the origin server. This string can be a domain name, Storage Account endpoint, Web App endpoint, IPv4 address or IPv6 address.
    http_port  = 80 #(Optional) The HTTP port of the origin. Defaults to 80.
    https_port = 443 #(Optional) The HTTPS port of the origin. Defaults to 443.
  }
}