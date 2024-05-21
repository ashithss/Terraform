#Manages a Resource Group.
resource "azurerm_resource_group" "example" {
  name     = "${var.prefix}-resources" #(Required) The Name which should be used for this Resource Group. Changing this forces a new Resource Group to be created.
  location = var.location #Required) The Azure Region where the Resource Group should exist. Changing this forces a new Resource Group to be created.
}
#Manages an Azure Storage Account.
resource "azurerm_storage_account" "example" {
  name                     = "${var.prefix}sa" #(Required) Specifies the name of the storage account. Only lowercase Alphanumeric characters allowed. Changing this forces a new resource to be created. This must be unique across the entire Azure service, not just within the resource group.
  resource_group_name      = azurerm_resource_group.example.name # (Required) The name of the resource group in which to create the storage account. Changing this forces a new resource to be created.
  location                 = azurerm_resource_group.example.location # (Required) Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created.
  account_tier             = "Standard" # (Required) Defines the Tier to use for this storage account. Valid options are Standard and Premium. For BlockBlobStorage and FileStorage accounts only Premium is valid. Changing this forces a new resource to be created.
  account_replication_type = "GRS" #(Required) Defines the type of replication to use for this storage account. Valid options are LRS, GRS, RAGRS, ZRS, GZRS and RAGZRS.
}

# Manages a Redis Cache.
resource "azurerm_redis_cache" "example" {
  name                = "${var.prefix}-cache" #(Required) The name of the Redis instance. Changing this forces a new resource to be created.
  location            = azurerm_resource_group.example.location # (Required) The location of the resource group. Changing this forces a new resource to be created.
  resource_group_name = azurerm_resource_group.example.name # (Required) The name of the resource group in which to create the Redis instance. Changing this forces a new resource to be created.
  capacity            = 3 #(Required) The size of the Redis cache to deploy. Valid values for a SKU family of C (Basic/Standard) are 0, 1, 2, 3, 4, 5, 6, and for P (Premium) family are 1, 2, 3, 4, 5.
  family              = "P" # (Required) The SKU family/pricing group to use. Valid values are C (for Basic/Standard SKU family) and P (for Premium)
  sku_name            = "Premium" # (Required) The SKU of Redis to use. Possible values are Basic, Standard and Premium.
  enable_non_ssl_port = false #(Optional) Enable the non-SSL port (6379) - disabled by default.

  redis_configuration {
    rdb_backup_enabled            = true # (Optional) Is Backup Enabled? Only supported on Premium SKUs. Defaults to false.
    rdb_backup_frequency          = 60 # (Optional) The Backup Frequency in Minutes. Only supported on Premium SKUs. Possible values are: 15, 30, 60, 360, 720 and 1440.
    rdb_backup_max_snapshot_count = 1 # (Optional) The maximum number of snapshots to create as a backup. Only supported for Premium SKUs.
    rdb_storage_connection_string = azurerm_storage_account.example.primary_blob_connection_string # (Optional) The Connection String to the Storage Account. Only supported for Premium SKUs. In the format: DefaultEndpointsProtocol=https;BlobEndpoint=${azurerm_storage_account.example.primary_blob_endpoint};AccountName=${azurerm_storage_account.example.name};AccountKey=${azurerm_storage_account.example.primary_access_key}.
  }
}