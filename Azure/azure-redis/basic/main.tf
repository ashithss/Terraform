# Resource block to create the azure resource group
resource "azurerm_resource_group" "example" {
  name     = "${var.prefix}-resources" #name of the resource group
  location = var.location #azure region for resource group
}

# NOTE: the Name used for Redis needs to be globally unique . Manages a Redis Cache.
resource "azurerm_redis_cache" "example" {
  name                = "${var.prefix}-redis" #(Required) The name of the redis cache. Changing this forces a new resource to be created.
  location            = azurerm_resource_group.example.location # (Required) The location/region where the redis cache is created. Changing this forces a new resource to be created.
  resource_group_name = azurerm_resource_group.example.name #(Required) The name of the resource group in which to create the redis cache . Changing this forces a new resource to be created.
  capacity            = 0 #(Required) The size of the Redis cache to deploy. Valid values for a SKU family of C (Basic/Standard) are 0, 1, 2, 3, 4, 5, 6, and for P (Premium) family are 1, 2, 3, 4, 5.
  family              = "C" #(Required) The SKU family/pricing group to use. Valid values are C (for Basic/Standard SKU family) and P (for Premium)
  sku_name            = "Basic" #(Required) The SKU of Redis to use. Possible values are Basic, Standard and Premium.
  enable_non_ssl_port = false #(Optional) Enable the non-SSL port (6379) - disabled by default.
}