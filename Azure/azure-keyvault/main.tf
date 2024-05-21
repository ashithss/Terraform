#Manages a azure resource group
resource "azurerm_resource_group" "rg" {
  name     = "${var.resource_group_name}-rg" #(Required) The Name which should be used for this Resource Group. 
  location = var.location # (Required) The Azure Region where the Resource Group should exist. 
  tags = merge(tomap({
  Name = var.name }))
}
#Use this data source to access the configuration of the AzureRM provider.
data "azurerm_client_config" "current" {}
#Manages a Key Vault.
resource "azurerm_key_vault" "key-vault" {
  name                            = var.kv_name #(Required) Specifies the name of the Key Vault. Changing this forces a new resource to be created. The name must be globally unique. If the vault is in a recoverable state then the vault will need to be purged before reusing the name.
  location                        = azurerm_resource_group.rg.location #(Required) Specifies the supported Azure location where the resource exists. 
  resource_group_name             = azurerm_resource_group.rg.name #(Required) The name of the resource group in which to create the Key Vault.
  enabled_for_deployment          = var.kv_enabled_for_deployment #(Optional) Boolean flag to specify whether Azure Virtual Machines are permitted to retrieve certificates stored as secrets from the key vault.
  enabled_for_disk_encryption     = var.kv_enabled_for_disk_encryption #(Optional) Boolean flag to specify whether Azure Disk Encryption is permitted to retrieve secrets from the vault and unwrap keys.
  enabled_for_template_deployment = var.kv_enabled_for_template_deployment#Optional) Boolean flag to specify whether Azure Resource Manager is permitted to retrieve secrets from the key vault.
  tenant_id                       = "df011998-1ab4-464a-a1b2-64c9719ed21b" # (Required) The Azure Active Directory tenant ID that should be used for authenticating requests to the key vault.
  sku_name                        = var.kv_sku_name #(Required) The Name of the SKU used for this Key Vault. Possible values are standard and premium.
  access_policy {
    tenant_id               = data.azurerm_client_config.current.tenant_id #(Required) The Azure Active Directory tenant ID that should be used for authenticating requests to the key vault. Must match the tenant_id used above.
    object_id               = "22f99cb0-305f-43ca-807f-82962fa75652" # (Required) The object ID of a user, service principal or security group in the Azure Active Directory tenant for the vault. The object ID must be unique for the list of access policies
    key_permissions         = ["Create", "Get", "List", "Purge", "Recover", ] #(Optional) List of key permissions. Possible values are Backup, Create, Decrypt, Delete, Encrypt, Get, Import, List, Purge, Recover, Restore, Sign, UnwrapKey, Update, Verify, WrapKey, Release, Rotate, GetRotationPolicy and SetRotationPolicy.
    secret_permissions      = ["Get", "List", "Purge", "Recover", "Set"] #(Optional) List of secret permissions, must be one or more from the following: Backup, Delete, Get, List, Purge, Recover, Restore and Set.
    certificate_permissions = ["Create", "Get", "List", "Purge", "Recover", "Update"]#(Optional) List of certificate permissions, must be one or more from the following: Backup, Create, Delete, DeleteIssuers, Get, GetIssuers, Import, List, ListIssuers, ManageContacts, ManageIssuers, Purge, Recover, Restore, SetIssuers and Update.
  } #(Optional) A list of up to 1024 objects describing access policies, as described below.
  depends_on = [azurerm_resource_group.rg]
}
#Manages a Key Vault Secret.
resource "azurerm_key_vault_secret" "key-vault-secret" {
  name         = var.kv_secret_name #(Required) Specifies the name of the Key Vault Secret. Changing this forces a new resource to be created.
  value        = var.kv_secret_value #(Required) Specifies the value of the Key Vault Secret.
  key_vault_id = azurerm_key_vault.key-vault.id # (Required) The ID of the Key Vault where the Secret should be created. 

  depends_on = [azurerm_resource_group.rg, azurerm_key_vault.key-vault]
}
