#Resource block to create the azure resource group
resource "azurerm_resource_group" "rg" {
  name     = "${var.resource_group_name}-rg" # (Required) The Name which should be used for this Resource Group. Changing this forces a new Resource Group to be created.
  location = var.location #(Required) The Azure Region where the Resource Group should exist. 
  tags = merge(tomap({ #(Optional) A mapping of tags which should be assigned to the Resource Group.
  Name = var.name }))
}
#Manages a Public IP Address.
resource "azurerm_public_ip" "example" {
  name                = "PublicIPForLB" #(Required) Specifies the name of the Public IP. Changing this forces a new Public IP to be created.
  location            = azurerm_resource_group.rg.location #(Required) Specifies the supported Azure location where the Public IP should exist. Changing this forces a new resource to be created.
  resource_group_name = azurerm_resource_group.rg.name #(Required) The name of the Resource Group where this Public IP should exist. Changing this forces a new Public IP to be created.
  allocation_method   = "Static" #(Required) Defines the allocation method for this IP address. Possible values are Static or Dynamic.
  sku = "Standard" #(Optional) The SKU of the Public IP. Accepted values are Basic and Standard. Defaults to Basic. Changing this forces a new resource to be created.
}
#Manages a Load Balancer Resource.
resource "azurerm_lb" "example" {
  name                = "TestLoadBalancer" #(Required) Specifies the name of the Load Balancer. Changing this forces a new resource to be created.
  location            = azurerm_resource_group.rg.location # (Required) Specifies the supported Azure Region where the Load Balancer should be created. Changing this forces a new resource to be created.
  resource_group_name = azurerm_resource_group.rg.name # (Required) The name of the Resource Group in which to create the Load Balancer. Changing this forces a new resource to be created.
  sku = "Standard" #(Optional) The SKU of the Azure Load Balancer. Accepted values are Basic, Standard and Gateway. Defaults to Basic. Changing this forces a new resource to be created.
  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.example.id #Optional) The ID of a Public IP Address which should be associated with the Load Balancer.
  }
}
#Manages a Load Balancer Backend Address Pool.
resource "azurerm_lb_backend_address_pool" "example" {
  loadbalancer_id = azurerm_lb.example.id #loadbalancer to used for address pool
  name            = "BackEndAddressPool" #name of the backend address pool
}
#Manages a virtual network including any configured subnets. Each subnet can optionally be configured with a security group to be associated with the subnet.
resource "azurerm_virtual_network" "vn" {
  name                = "${var.name}-vn" #name of the the virtual name
  resource_group_name = azurerm_resource_group.rg.name #resource group for the virtual network
  address_space       = ["10.0.0.0/16"] #(Required) The address space that is used the virtual network. You can supply more than one address space.
  location            = azurerm_resource_group.rg.location #location of the virtual network
  tags = merge(tomap({
  Name = var.name }))
}
#Manages a Backend Address within a Backend Address Pool.
resource "azurerm_lb_backend_address_pool_address" "example" {
  name                    = "example" #name of the backend adress pool
  backend_address_pool_id = azurerm_lb_backend_address_pool.example.id #id of the  backend address pool
  virtual_network_id      = azurerm_virtual_network.vn.id #id of the virtual network
  ip_address              = "10.0.0.1" #backend ip address
}
#Manages a Load Balancer NAT pool.
resource "azurerm_lb_nat_pool" "example" {
  resource_group_name            = azurerm_resource_group.rg.name # (Required) The name of the resource group in which to create the resource.
  loadbalancer_id                = azurerm_lb.example.id # (Required) The name of the resource group in which to create the resource.
  name                           = "SampleApplicationPool" # (Required) Specifies the name of the NAT pool. Changing this forces a new resource to be created.
  protocol                       = "Tcp" #(Required) The transport protocol for the external endpoint. Possible values are All, Tcp and Udp.
  frontend_port_start            = 80 #(Required) The first port number in the range of external ports that will be used to provide Inbound NAT to NICs associated with this Load Balancer. Possible values range between 1 and 65534, inclusive.
  frontend_port_end              = 81 #(Required) The last port number in the range of external ports that will be used to provide Inbound NAT to NICs associated with this Load Balancer. Possible values range between 1 and 65534, inclusive.
  backend_port                   = 8080 # (Required) The port used for the internal endpoint. Possible values range between 1 and 65535, inclusive.
  frontend_ip_configuration_name = "PublicIPAddress" #(Required) The name of the frontend IP configuration exposing this rule.
}
#Manages a Load Balancer NAT Rule.
resource "azurerm_lb_nat_rule" "example1" {
  resource_group_name            = azurerm_resource_group.rg.name #(Required) The name of the resource group in which to create the resource.
  loadbalancer_id                = azurerm_lb.example.id #(Required) The ID of the Load Balancer in which to create the NAT Rule. 
  name                           = "RDPAccess" # (Required) Specifies the name of the NAT Rule. Changing this forces a new resource to be created.
  protocol                       = "Tcp" #(Required) The transport protocol for the external endpoint. Possible values are Udp, Tcp or All.
  frontend_port    =                 3000 #(Optional) The port for the external endpoint. Port numbers for each Rule must be unique within the Load Balancer. Possible values range between 1 and 65534, inclusive.
  backend_port                   = 3389 #(Required) The port used for internal connections on the endpoint. Possible values range between 1 and 65535, inclusive.
  frontend_ip_configuration_name = "PublicIPAddress"  #(Required) The name of the frontend IP configuration exposing this rule.
}
#Manages a Load Balancer Outbound Rule.
resource "azurerm_lb_outbound_rule" "example" {
  name                    = "OutboundRule" #(Required) Specifies the name of the Outbound Rule. Changing this forces a new resource to be created.
  loadbalancer_id         = azurerm_lb.example.id #(Required) The ID of the Load Balancer in which to create the Outbound Rule. Changing this forces a new resource to be created.
  protocol                = "Tcp" # (Required) The transport protocol for the external endpoint. Possible values are Udp, Tcp or All.
  backend_address_pool_id = azurerm_lb_backend_address_pool.example.id # (Required) The ID of the Backend Address Pool. Outbound traffic is randomly load balanced across IPs in the backend IPs.

  frontend_ip_configuration {
    name = "PublicIPAddress" #(Required) The name of the Frontend IP Configuration.
  }

}
#Manages a LoadBalancer Probe Resource.
resource "azurerm_lb_probe" "example" {
  loadbalancer_id = azurerm_lb.example.id #(Required) The ID of the LoadBalancer in which to create the NAT Rule. Changing this forces a new resource to be created.
  name            = "ssh-running-probe" #(Required) Specifies the name of the Probe. Changing this forces a new resource to be created.
  port            = 22 #(Required) Port on which the Probe queries the backend endpoint. Possible values range from 1 to 65535, inclusive.
}
#Manages a Load Balancer Rule.
resource "azurerm_lb_rule" "example" {
  loadbalancer_id                = azurerm_lb.example.id #(Required) The ID of the Load Balancer in which to create the Rule. Changing this forces a new resource to be created.
  name                           = "LBRule" #(Required) Specifies the name of the LB Rule. Changing this forces a new resource to be created.
  protocol                       = "Tcp" # (Required) The transport protocol for the external endpoint. Possible values are Tcp, Udp or All.
  frontend_port                  = 3389 # (Required) The port for the external endpoint. Port numbers for each Rule must be unique within the Load Balancer. Possible values range between 0 and 65534, inclusive.
  backend_port                   = 3389 # (Required) The port used for internal connections on the endpoint. Possible values range between 0 and 65535, inclusive.
  frontend_ip_configuration_name = "PublicIPAddress" #Required) The name of the frontend IP configuration to which the rule is associated.
  disable_outbound_snat = true #(Optional) Is snat enabled for this Load Balancer Rule? Default false.
}
