#generates random pet names that are intended to be used as unique identifiers for other resources
resource "random_pet" "name_prefix" {
  prefix = var.name_prefix
  length = 1
}
#Resource block to create the azure resource group
resource "azurerm_resource_group" "default" {
  name     = random_pet.name_prefix.id
  location = var.location
}
#Manages a virtual network including any configured subnets. Each subnet can optionally be configured with a security group to be associated with the subnet.
resource "azurerm_virtual_network" "default" {
  name                = "${random_pet.name_prefix.id}-vnet" #(Required) The name of the virtual network. Changing this forces a new resource to be created.
  location            = azurerm_resource_group.default.location # (Required) The location/region where the virtual network is created. Changing this forces a new resource to be created.
  resource_group_name = azurerm_resource_group.default.name #(Required) The name of the resource group in which to create the virtual network. Changing this forces a new resource to be created.
  address_space       = ["10.0.0.0/16"] #(Required) The address space that is used the virtual network. You can supply more than one address space.
}
#Manages a network security group that contains a list of network security rules. Network security groups enable inbound or outbound traffic to be enabled or denied.
resource "azurerm_network_security_group" "default" {
  name                = "${random_pet.name_prefix.id}-nsg" #(Required) Specifies the name of the network security group. Changing this forces a new resource to be created.
  location            = azurerm_resource_group.default.location # (Required) Specifies the supported Azure location where the resource exists. 
  resource_group_name = azurerm_resource_group.default.name # (Required) The name of the resource group in which to create the network security group. Changing this forces a new resource to be created.
 #(Optional) List of objects representing security rules, as defined below.
  security_rule {
    name                       = "test123" # (Required) The name of the security rule.
    priority                   = 100 # (Required) Specifies the priority of the rule. The value can be between 100 and 4096. The priority number must be unique for each rule in the collection. The lower the priority number, the higher the priority of the rule.
    direction                  = "Inbound" #(Required) The direction specifies if rule will be evaluated on incoming or outgoing traffic. Possible values are Inbound and Outbound.
    access                     = "Allow" #(Required) Specifies whether network traffic is allowed or denied. Possible values are Allow and Deny.
    protocol                   = "Tcp"  #(Required) Network protocol this rule applies to. Possible values include Tcp, Udp, Icmp, Esp, Ah or * (which matches all).
    source_port_range          = "*"  #(Optional) Source Port or Range. Integer or range between 0 and 65535 or * to match any. This is required if source_port_ranges is not specified.
    destination_port_range     = "*" #(Optional) Destination Port or Range. Integer or range between 0 and 65535 or * to match any. This is required if destination_port_ranges is not specified.
    source_address_prefix      = "*" #(Optional) CIDR or source IP range or * to match any IP. Tags such as VirtualNetwork, AzureLoadBalancer and Internet can also be used. This is required if source_address_prefixes is not specified.
    destination_address_prefix = "*" #(Optional) CIDR or destination IP range or * to match any IP. Tags such as VirtualNetwork, AzureLoadBalancer and Internet can also be used. This is required if destination_address_prefixes is not specified.
  }
}
#Manages a subnet. Subnets represent network segments within the IP space defined by the virtual network.
resource "azurerm_subnet" "default" {
  name                 = "${random_pet.name_prefix.id}-subnet" #Specifies the name of the Subnet.
  virtual_network_name = azurerm_virtual_network.default.name # Specifies the name of the Virtual Network this Subnet is located within.
  resource_group_name  = azurerm_resource_group.default.name #Specifies the name of the resource group the Virtual Network is located in.
  address_prefixes     = ["10.0.2.0/24"] #(Required) The address prefixes to use for the subnet.
  service_endpoints    = ["Microsoft.Storage"] #(Optional) The list of Service endpoints to associate with the subnet. Possible values include: Microsoft.AzureActiveDirectory, Microsoft.AzureCosmosDB, Microsoft.ContainerRegistry, Microsoft.EventHub, Microsoft.KeyVault, Microsoft.ServiceBus, Microsoft.Sql, Microsoft.Storage, Microsoft.Storage.Global and Microsoft.Web.
  #(Optional) One or more delegation blocks
  delegation {
    name = "fs"

    service_delegation {
      name = "Microsoft.DBforPostgreSQL/flexibleServers"
      #name - (Required) The name of service to delegate to. Possible values are GitHub.Network/networkSettings, Microsoft.ApiManagement/service, Microsoft.Apollo/npu, Microsoft.App/environments, Microsoft.App/testClients, Microsoft.AVS/PrivateClouds, Microsoft.AzureCosmosDB/clusters, Microsoft.BareMetal/AzureHostedService, Microsoft.BareMetal/AzureHPC, Microsoft.BareMetal/AzurePaymentHSM, Microsoft.BareMetal/AzureVMware, Microsoft.BareMetal/CrayServers, Microsoft.BareMetal/MonitoringServers, Microsoft.Batch/batchAccounts, Microsoft.CloudTest/hostedpools, Microsoft.CloudTest/images, Microsoft.CloudTest/pools, Microsoft.Codespaces/plans, Microsoft.ContainerInstance/containerGroups, Microsoft.ContainerService/managedClusters, Microsoft.ContainerService/TestClients, Microsoft.Databricks/workspaces, Microsoft.DBforMySQL/flexibleServers, Microsoft.DBforMySQL/servers, Microsoft.DBforMySQL/serversv2, Microsoft.DBforPostgreSQL/flexibleServers, Microsoft.DBforPostgreSQL/serversv2, Microsoft.DBforPostgreSQL/singleServers, Microsoft.DelegatedNetwork/controller, Microsoft.DevCenter/networkConnection, Microsoft.DocumentDB/cassandraClusters, Microsoft.Fidalgo/networkSettings, Microsoft.HardwareSecurityModules/dedicatedHSMs, Microsoft.Kusto/clusters, Microsoft.LabServices/labplans, Microsoft.Logic/integrationServiceEnvironments, Microsoft.MachineLearningServices/workspaces, Microsoft.Netapp/volumes, Microsoft.Network/dnsResolvers, Microsoft.Network/fpgaNetworkInterfaces, Microsoft.Network/networkWatchers., Microsoft.Network/virtualNetworkGateways, Microsoft.Orbital/orbitalGateways, Microsoft.PowerPlatform/enterprisePolicies, Microsoft.PowerPlatform/vnetaccesslinks, Microsoft.ServiceFabricMesh/networks, Microsoft.ServiceNetworking/trafficControllers, Microsoft.Singularity/accounts/networks, Microsoft.Singularity/accounts/npu, Microsoft.Sql/managedInstances, Microsoft.Sql/managedInstancesOnebox, Microsoft.Sql/managedInstancesStage, Microsoft.Sql/managedInstancesTest, Microsoft.StoragePool/diskPools, Microsoft.StreamAnalytics/streamingJobs, Microsoft.Synapse/workspaces, Microsoft.Web/hostingEnvironments, Microsoft.Web/serverFarms, NGINX.NGINXPLUS/nginxDeployments, PaloAltoNetworks.Cloudngfw/firewalls, and Qumulo.Storage/fileSystems.
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
      ]
      #name - actions - (Optional) A list of Actions which should be delegated. This list is specific to the service to delegate to. Possible values are Microsoft.Network/networkinterfaces/*, Microsoft.Network/publicIPAddresses/join/action, Microsoft.Network/publicIPAddresses/read, Microsoft.Network/virtualNetworks/read, Microsoft.Network/virtualNetworks/subnets/action, Microsoft.Network/virtualNetworks/subnets/join/action, Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action, and Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action.
    }
  }
}
#Associates a Network Security Group with a Subnet within a Virtual Network.
resource "azurerm_subnet_network_security_group_association" "default" {
  subnet_id                 = azurerm_subnet.default.id # (Required) The ID of the Subnet. Changing this forces a new resource to be created.
  network_security_group_id = azurerm_network_security_group.default.id #(Required) The ID of the Network Security Group which should be associated with the Subnet. Changing this forces a new resource to be created.
}
#Enables you to manage Private DNS zones within Azure DNS. These zones are hosted on Azure's name servers.
resource "azurerm_private_dns_zone" "default" {
  name                = "${random_pet.name_prefix.id}-pdz.postgres.database.azure.com" # (Required) The name of the Private DNS Zone. Must be a valid domain name. 
  resource_group_name = azurerm_resource_group.default.name # (Required) Specifies the resource group where the resource exists.

  depends_on = [azurerm_subnet_network_security_group_association.default]
}
#Enables you to manage Private DNS zone Virtual Network Links. These Links enable DNS resolution and registration inside Azure Virtual Networks using Azure Private DNS.
resource "azurerm_private_dns_zone_virtual_network_link" "default" {
  name                  = "${random_pet.name_prefix.id}-pdzvnetlink.com" #(Required) The name of the Private DNS Zone Virtual Network Link. Changing this forces a new resource to be created
  private_dns_zone_name = azurerm_private_dns_zone.default.name # (Required) The name of the Private DNS zone (without a terminating dot). Changing this forces a new resource to be created.
  virtual_network_id    = azurerm_virtual_network.default.id # (Required) The ID of the Virtual Network that should be linked to the DNS Zone. Changing this forces a new resource to be created.
  resource_group_name   = azurerm_resource_group.default.name #(Required) Specifies the resource group where the Private DNS Zone exists. Changing this forces a new resource to be created.
}

resource "random_password" "pass" {
  length = 20
}
#Manages a PostgreSQL Flexible Server.
resource "azurerm_postgresql_flexible_server" "default" {
  name                   = "${random_pet.name_prefix.id}-server" #(Required) The name which should be used for this PostgreSQL Flexible Server. Changing this forces a new PostgreSQL Flexible Server to be created.
  resource_group_name    = azurerm_resource_group.default.name # (Required) The name of the Resource Group where the PostgreSQL Flexible Server should exist. Changing this forces a new PostgreSQL Flexible Server to be created.
  location               = azurerm_resource_group.default.location # (Required) The Azure Region where the PostgreSQL Flexible Server should exist. Changing this forces a new PostgreSQL Flexible Server to be created.
  version                = "13" #(Optional) The version of PostgreSQL Flexible Server to use. Possible values are 11,12, 13, 14 and 15. Required when create_mode is Default.
  delegated_subnet_id    = azurerm_subnet.default.id #(Optional) The ID of the virtual network subnet to create the PostgreSQL Flexible Server. The provided subnet should not have any other resource deployed in it and this subnet will be delegated to the PostgreSQL Flexible Server, if not already delegated.
  private_dns_zone_id    = azurerm_private_dns_zone.default.id #(Optional) The ID of the private DNS zone to create the PostgreSQL Flexible Server. Changing this forces a new PostgreSQL Flexible Server to be created.
  administrator_login    = "adminTerraform" #Optional) The Administrator login for the PostgreSQL Flexible Server. Required when create_mode is Default and authentication.password_auth_enabled is true.
  administrator_password = random_password.pass.result #(Optional) The Password associated with the administrator_login for the PostgreSQL Flexible Server. Required when create_mode is Default and authentication.password_auth_enabled is true.
  zone                   = "1" #Optional) Specifies the Availability Zone in which the PostgreSQL Flexible Server should be located.
  storage_mb             = 32768 #(Optional) The max storage allowed for the PostgreSQL Flexible Server. Possible values are 32768, 65536, 131072, 262144, 524288, 1048576, 2097152, 4194304, 8388608, 16777216 and 33553408.
  sku_name               = "GP_Standard_D2s_v3" #(Optional) The SKU Name for the PostgreSQL Flexible Server. The name of the SKU, follows the tier + name pattern (e.g. B_Standard_B1ms, GP_Standard_D2s_v3, MO_Standard_E4s_v3).
  backup_retention_days  = 7 #Optional) The backup retention days for the PostgreSQL Flexible Server. Possible values are between 7 and 35 days.

  depends_on = [azurerm_private_dns_zone_virtual_network_link.default]
}
#Manages a PostgreSQL Flexible Server Database.
resource "azurerm_postgresql_flexible_server_database" "default" {
  name      = "${random_pet.name_prefix.id}-db" # (Required) The name which should be used for this Azure PostgreSQL Flexible Server Database. Changing this forces a new Azure PostgreSQL Flexible Server Database to be created.
  server_id = azurerm_postgresql_flexible_server.default.id #(Required) The ID of the Azure PostgreSQL Flexible Server from which to create this PostgreSQL Flexible Server Database. Changing this forces a new Azure PostgreSQL Flexible Server Database to be created.
  collation = "en_US.UTF8" #Optional) Specifies the Collation for the Azure PostgreSQL Flexible Server Database, which needs to be a valid PostgreSQL Collation. Defaults to en_US.utf8. Changing this forces a new Azure PostgreSQL Flexible Server Database to be created.
  charset   = "UTF8" #(Optional) Specifies the Charset for the Azure PostgreSQL Flexible Server Database, which needs to be a valid PostgreSQL Charset. Defaults to UTF8
}