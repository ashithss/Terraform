#Resource block to create the azure resource group
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name #(Required) The Name which should be used for this Resource Group. Changing this forces a new Resource Group to be created.
  location = var.location # (Required) The Azure Region where the Resource Group should exist. Changing this forces a new Resource Group to be created.
  tags = merge(tomap({ #(Optional) A mapping of tags which should be assigned to the Resource Group.
  Name = var.name }))
}
#Manages a virtual network including any configured subnets. Each subnet can optionally be configured with a security group to be associated with the subnet.
resource "azurerm_virtual_network" "vn" {
  name                = "${var.name}-vn" #(Required) The name of the virtual network. Changing this forces a new resource to be created.
  resource_group_name = azurerm_resource_group.rg.name # (Required) The name of the resource group in which to create the virtual network. Changing this forces a new resource to be created.
  address_space       = ["10.0.0.0/16"] #(Required) The address space that is used the virtual network. You can supply more than one address space.
  location            = azurerm_resource_group.rg.location #(Required) The location/region where the virtual network is created. Changing this forces a new resource to be created.
  tags = merge(tomap({
  Name = var.name }))
}

#Manages a subnet. Subnets represent network segments within the IP space defined by the virtual network.
resource "azurerm_subnet" "sb" {
  name                 = "${var.name}-sb" #name of the subnet
  resource_group_name  = azurerm_resource_group.rg.name # (Required) The name of the resource group in which to create the subnet Changing this forces a new resource to be created.
  virtual_network_name = azurerm_virtual_network.vn.name#name of the virtual name in which subnet will be present
  address_prefixes     = ["10.0.2.0/24"] #(Required) The address prefixes to use for the subnet.
}
#Manages a network security group that contains a list of network security rules. Network security groups enable inbound or outbound traffic to be enabled or denied.
resource "azurerm_network_security_group" "nsg" {
  name                = "${var.name}-nsg" #(Required) Specifies the name of the network security group. Changing this forces a new resource to be created.
  resource_group_name = azurerm_resource_group.rg.name # (Required) The name of the resource group in which to create the network security group. Changing this forces a new resource to be created.
  location            = azurerm_resource_group.rg.location #(Required) Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created.

  tags = merge(tomap({
  Name = var.name }))
}
#Manages a Network Security Rule.
resource "azurerm_network_security_rule" "nsr" {
  count                       = length(var.rule_list)
  resource_group_name         = azurerm_resource_group.rg.name #(Required) The name of the resource group in which to create the Network Security Rule. Changing this forces a new resource to be created.
  network_security_group_name = azurerm_network_security_group.nsg.name #(Required) The name of the Network Security Group that we want to attach the rule to. Changing this forces a new resource to be created.

  name                       = element(split(",", element(var.rule_list, count.index)), 0) #(Required) Specifies the priority of the rule. The value can be between 100 and 4096. The priority number must be unique for each rule in the collection. The lower the priority number, the higher the priority of the rule.
  priority                   = element(split(",", element(var.rule_list, count.index)), 1) #(Required) Network protocol this rule applies to. Possible values include Tcp, Udp, Icmp, Esp, Ah or * (which matches all).
  direction                  = element(split(",", element(var.rule_list, count.index)), 2) #(Required) The direction specifies if rule will be evaluated on incoming or outgoing traffic. Possible values are Inbound and Outbound.
  access                     = element(split(",", element(var.rule_list, count.index)), 3) # (Required) Specifies whether network traffic is allowed or denied. Possible values are Allow and Deny.
  protocol                   = element(split(",", element(var.rule_list, count.index)), 4) #(Required) Network protocol this rule applies to. Possible values include Tcp, Udp, Icmp, Esp, Ah or * (which matches all).
  source_port_range          = element(split(",", element(var.rule_list, count.index)), 5) #(Optional) Source Port or Range. Integer or range between 0 and 65535 or * to match any. This is required if source_port_ranges is not specified.
  destination_port_range     = element(split(",", element(var.rule_list, count.index)), 6) #(Optional) Destination Port or Range. Integer or range between 0 and 65535 or * to match any. This is required if destination_port_ranges is not specified.
  source_address_prefix      = element(split(",", element(var.rule_list, count.index)), 7) # (Optional) CIDR or source IP range or * to match any IP. Tags such as VirtualNetwork, AzureLoadBalancer and Internet can also be used. This is required if source_address_prefixes is not specified.
  destination_address_prefix = element(split(",", element(var.rule_list, count.index)), 8) #(Optional) CIDR or destination IP range or * to match any IP. Tags such as VirtualNetwork, AzureLoadBalancer and Internet can also be used. Besides, it also supports all available Service Tags like ‘Sql.WestEurope‘, ‘Storage.EastUS‘, etc. You can list the available service tags with the CLI: shell az network list-service-tags --location westcentralus. For further information please see Azure CLI - az network list-service-tags. This is required if destination_address_prefixes is not specified.
}
#Manages a Public IP Address.
resource "azurerm_public_ip" "pi" {
  count = var.cou

  # Resource location
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name #(Required) The name of the Resource Group where this Public IP should exist. Changing this forces a new Public IP to be created.

  # Public IP Information
  name              = "${lower(var.name)}-ip-vm-${format(var.count_format, var.count_offset + count.index + 1)}" #(Required) Specifies the name of the Public IP. Changing this forces a new Public IP to be created
  domain_name_label = "${lower(var.name)}-${format(var.count_format, var.count_offset + count.index + 1)}" #(Optional) Label for the Domain Name. Will be used to make up the FQDN. If a domain name label is specified, an A DNS record is created for the public IP in the Microsoft Azure DNS system.
  allocation_method = "Dynamic" # (Required) Defines the allocation method for this IP address. Possible values are Static or Dynamic.
  tags = merge(tomap({
  Name = var.name }))
}

# All VMs require a network interface
resource "azurerm_network_interface" "ni" {
  count = var.cou

  # Resource location
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name #(Required) The name of the Resource Group where this network interface should exist. Changing this forces a new network interface to be created.

  # NIC Name Information
  name                    = "${var.name}-ni-vm-${format(var.count_format, var.count_offset + count.index + 1)}"
  internal_dns_name_label = "${var.name}-${format(var.count_format, var.count_offset + count.index + 1)}"
  # network_security_group_id = "${azurerm_network_security_group.nsg.id}"

  ip_configuration {
    name                          = "${var.name}-${format(var.count_format, var.count_offset + count.index + 1)}" #(Required) A name used for this IP Configuration.
    subnet_id                     = azurerm_subnet.sb.id # (Optional) The ID of the Subnet where this Network Interface should be located in.
    private_ip_address_allocation = var.private_ip_address_allocation #(Required) The allocation method used for the Private IP Address. Possible values are Dynamic and Static.
    public_ip_address_id          = element(azurerm_public_ip.pi.*.id, count.index) #(Optional) Reference to a Public IP Address to associate with this NIC
  }

  tags = merge(tomap({
  Name = var.name }))
}