#Manages a Resource Group.
resource "azurerm_resource_group" "example" {
  name     = "${var.prefix}-resources" #(Required) The Name which should be used for this Resource Group. Changing this forces a new Resource Group to be created.
  location = var.location #Required) The Azure Region where the Resource Group should exist. Changing this forces a new Resource Group to be created.
}

# Manages a Redis Cache.
resource "azurerm_redis_cache" "example" {
  name                = "${var.prefix}-cache" # (Required) The name of the Redis instance. Changing this forces a new resource to be created.
  location            = azurerm_resource_group.example.location # (Required) The location of the resource group. Changing this forces a new resource to be created.
  resource_group_name = azurerm_resource_group.example.name # (Required) The name of the resource group in which to create the Redis instance. Changing this forces a new resource to be created.
  capacity            = 2 # (Required) The size of the Redis cache to deploy. Valid values for a SKU family of C (Basic/Standard) are 0, 1, 2, 3, 4, 5, 6, and for P (Premium) family are 1, 2, 3, 4, 5.
  family              = "C" #(Required) The SKU family/pricing group to use. Valid values are C (for Basic/Standard SKU family) and P (for Premium)
  sku_name            = "Standard" # (Required) The SKU of Redis to use. Possible values are Basic, Standard and Premium.
  enable_non_ssl_port = false # (Optional) Enable the non-SSL port (6379) - disabled by default.
  minimum_tls_version = "1.2" #(Optional) The minimum TLS version. Possible values are 1.0, 1.1 and 1.2. Defaults to 1.0.

  redis_configuration {}
}