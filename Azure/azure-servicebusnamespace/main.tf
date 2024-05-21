# Resource block to create the azure resource group
resource "azurerm_resource_group" "test" {
  name     = "terraform-servicebus" #name of the resource group
  location = "${var.location}" #loaction of the resource group
}
#Manages a ServiceBus Namespace.
resource "azurerm_servicebus_namespace" "demosb123321" {
  name                = "${var.servicebus_name}" # name of the service bus namespace
  location            = "${var.location}" #location of the service bus namespace
  resource_group_name = "${azurerm_resource_group.test.name}" #resource group of the namespace
  sku                 = "Basic" #(Required) Defines which tier to use. Options are Basic, Standard or Premium. Please note that setting this field to Premium will force the creation of a new resource.
  tags = {
    source = "terraform" #(optional)
  }
}
#Manages a ServiceBus Namespace authorization Rule within a ServiceBus.
resource "azurerm_servicebus_namespace_authorization_rule" "example" {
  name         = "examplerule" #name of the rule
  namespace_id = azurerm_servicebus_namespace.demosb123321.id #(Required) Specifies the ID of the ServiceBus Namespace.
  listen = true # (Optional) Grants listen access to this this Authorization Rule.
  send   = true #(Optional) Grants send access to this this Authorization Rule. Defaults to false.
  manage = false #(Optional) Grants manage access to this this Authorization Rule. When this property is true - both listen and send must be too. Defaults to false.
}