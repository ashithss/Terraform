#Manages a azure resource group
resource "azurerm_resource_group" "rg" {
  name     = "${var.resource_group_name}-rg" # (Required) The Name which should be used for this Resource Group. 
  location = var.location # (Required) The Azure Region where the Resource Group should exist. 
  tags = merge(tomap({ # (Optional) A mapping of tags which should be assigned to the Resource Group.
  Name = var.name }))
}
#Enables you to manage DNS zones within Azure DNS. These zones are hosted on Azure's name servers to which you can delegate the zone from the parent domain.
resource "azurerm_dns_zone" "this" {
  name                = "${var.domain_prefix}.${var.domain_name}" #(Required) The name of the DNS Zone. Must be a valid domain name. 
  resource_group_name = azurerm_resource_group.rg.name #(Required) Specifies the resource group where the resource exists. 
  tags                = var.tags #(Optional) A mapping of tags to assign to the resource.
}