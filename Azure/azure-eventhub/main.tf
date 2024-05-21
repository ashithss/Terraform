#Manages a azure resource group
resource "azurerm_resource_group" "events" {
  name     = var.resource_group_name # (Required) The Name which should be used for this Resource Group. 
  location = var.location # (Required) The Azure Region where the Resource Group should exist. 
  tags = var.tags #(Optional) A mapping of tags to assign to the resource.
}
#Manages an EventHub Namespace.
resource "azurerm_eventhub_namespace" "events" {
  name                = "${var.name}-ns" #(Required) Specifies the name of the EventHub Namespace resource.
  location            = azurerm_resource_group.events.location # (Required) Specifies the supported Azure location where the resource exists.
  resource_group_name = azurerm_resource_group.events.name # (Required) The name of the resource group in which to create the namespace.
  sku                 = var.sku # (Required) Defines which tier to use. Valid options are Basic, Standard, and Premium. Please note that setting this field to Premium will force the creation of a new resource.
  capacity            = var.capacity # (Optional) Specifies the Capacity / Throughput Units for a Standard SKU namespace. Default capacity has a maximum of 2, but can be increased in blocks of 2 on a committed purchase basis. Defaults to 1.
  tags = var.tags  #(Optional) A mapping of tags to assign to the resource.
}
