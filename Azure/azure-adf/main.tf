#Manges the azure resource group
resource "azurerm_resource_group" "rg" {
  name     = "${var.resource_group_name}-rg" #(Required) The Name which should be used for this Resource Group. 
  location = var.location #(Required) The Azure Region where the Resource Group should exist. Changing this forces a new Resource Group to be created.
  tags = merge(tomap({ # (Optional) A mapping of tags which should be assigned to the Resource Group.
  Name = var.name }))
}

#Manages an Azure Data Factory (Version 2).
resource "azurerm_data_factory" "example" {
  name                = "${var.name}-adf" #(Required) Specifies the name of the Data Factory. Changing this forces a new resource to be created. Must be globally unique.
  location            = azurerm_resource_group.rg.location #(Required) Specifies the supported Azure location where the resource exists. 
  resource_group_name = azurerm_resource_group.rg.name #(Required) The name of the resource group in which to create the Data Factory. Changing this forces a new resource to be created.
  identity { #(Optional) An identity block as defined below.
    type = "SystemAssigned" #(Required) Specifies the type of Managed Service Identity that should be configured on this Data Factory. Possible values are SystemAssigned, UserAssigned, SystemAssigned, UserAssigned (to enable both).
  }
}

#Manages a Data Factory Self-hosted Integration Runtime.
resource "azurerm_data_factory_integration_runtime_self_hosted" "example" {
  name                = "shir-${azurerm_data_factory.example.name}" #(Required) The name which should be used for this Data Factory. Changing this forces a new Data Factory Self-hosted Integration Runtime to be created.
  data_factory_id    = azurerm_data_factory.example.id # (Required) The Data Factory ID in which to associate the Linked Service with
}