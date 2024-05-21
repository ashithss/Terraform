# Resource block to create the azure resource group
resource "azurerm_resource_group" "rg" {
  name     = "${var.resource_group_name}-rg" #name of the resource group
  location = "${var.location}" #azure region for the resource group

   tags = merge(tomap({
    Name = var.name}))
}
#Manages an Azure Storage Account.
resource "azurerm_storage_account" "sa" {
  name                     = "${var.account_name}sa" #(Required) Specifies the name of the storage account. Only lowercase Alphanumeric characters allowed. Changing this forces a new resource to be created. This must be unique across the entire Azure service, not just within the resource group.
  resource_group_name      = "${var.resource_group_name}-rg" #(Required) The name of the resource group in which to create the storage account. Changing this forces a new resource to be created.
  location                 = "${var.location}" #(Required) Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created.
  account_tier             = "${var.account_tier}"#(Required) Defines the Tier to use for this storage account. Valid options are Standard and Premium. For BlockBlobStorage and FileStorage accounts only Premium is valid. Changing this forces a new resource to be created.
  account_replication_type = "${var.account_replication_type}" # (Required) Defines the type of replication to use for this storage account. Valid options are LRS, GRS, RAGRS, ZRS, GZRS and RAGZRS.
  tags = merge(tomap({
    Name = var.name}))
}
#Manages an Azure Storage container.
resource "azurerm_storage_container" "sc" {
  name                  = "${var.name}-sc" #(Required) The name of the Container which should be created within the Storage Account. Changing this forces a new resource to be created.
  storage_account_name  = "${var.account_name}sa" #(Required) The name of the Storage Account where the Container should be created. Changing this forces a new resource to be created.
  container_access_type = "${var.container_access_type}" # (Optional) The Access Level configured for this Container. Possible values are blob, container or private. Defaults to private.
}
#Manages a Blob within a Storage Container.
resource "azurerm_storage_blob" "blob" {
  name                   = "${var.name}-blob" #(Required) The name of the storage blob. Must be unique within the storage container the blob is located. Changing this forces a new resource to be created.
  storage_account_name   = "${var.account_name}sa" # (Required) Specifies the storage account in which to create the storage container. Changing this forces a new resource to be created. Changing this forces a new resource to be created.
  storage_container_name = "${var.name}-sc" #(Required) The name of the storage container in which this blob should be created. Changing this forces a new resource to be created.
  type                   = "${var.type}" # (Required) The type of the storage blob to be created. Possible values are Append, Block or Page. Changing this forces a new resource to be created.
  size                   = "${var.size}" # (Optional) Used only for page blobs to specify the size in bytes of the blob to be created. Must be a multiple of 512. Defaults to 0. Changing this forces a new resource to be created.
}
#Manages an Azure Storage queue.
resource "azurerm_storage_queue" "queue" {
  name                 = "${var.name}-queue" #(Required) The name of the storage queue. Changing this forces a new resource to be created.
  storage_account_name = "${var.account_name}sa" #(Required) Specifies the storage account in which to create the storage queue.. 
}
#Manages an Azure Storage share.
resource "azurerm_storage_share" "share" {
  name                 = "${var.name}-share" # (Required) The name of the share. Must be unique within the storage account where the share is located. Changing this forces a new resource to be created.
  storage_account_name = "${var.account_name}sa" #(Required) Specifies the storage account in which to create the share. 
  quota                = "${var.quota}" # (Required) The maximum size of the share, in gigabytes.
}
#Manages an Azure Storage table.
resource "azurerm_storage_table" "table" {
  name                 = "${var.name}table" # the name of table.
  storage_account_name = "${var.account_name}sa" #Specifies the storage account to create the table.
}