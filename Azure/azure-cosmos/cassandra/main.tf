provider "azurerm" {
  features {}
}
#Manages a azure resource group
resource "azurerm_resource_group" "example" {
  name     = "accexample-rg"
  location = "West Europe"
}
#Manages a virtual network including any configured subnets. Each subnet can optionally be configured with a security group to be associated with the subnet.
resource "azurerm_virtual_network" "example" {
  name                = "example-vnet" ##(Required) The name of the virtual network.
  location            = azurerm_resource_group.example.location #(Required) The name of the location.
  resource_group_name = azurerm_resource_group.example.name #(Required) The name of the resource group.
  address_space       = ["10.0.0.0/16"]#(Required) The address space that is used the virtual network. You can supply more than one address space.
}
#Manages a subnet. Subnets represent network segments within the IP space defined by the virtual network.
resource "azurerm_subnet" "example" {
  name                 = "example-subnet" ## Specifies the name of the Subnet.
  resource_group_name  = azurerm_resource_group.example.name #Specifies the name of the resource group the Virtual Network is located in.
  virtual_network_name = azurerm_virtual_network.example.name #Specifies the name of the Virtual Network this Subnet is located within.
  address_prefixes     = ["10.0.1.0/24"] #(Required) The address prefixes to use for the subnet.
}
#Manages a service principal associated with an application within Azure Active Directory.
data "azuread_service_principal" "example" {
  display_name = "Azure Cosmos DB"
}
#Assigns a given Principal (User or Group) to a given Role.
resource "azurerm_role_assignment" "example" {
  scope                = azurerm_virtual_network.example.id #(Required) The scope at which the Role Assignment applies to, such as /subscriptions/0b1f6471-1bf0-4dda-aec3-111122223333, /subscriptions/0b1f6471-1bf0-4dda-aec3-111122223333/resourceGroups/myGroup, or /subscriptions/0b1f6471-1bf0-4dda-aec3-111122223333/resourceGroups/myGroup/providers/Microsoft.Compute/virtualMachines/myVM, or /providers/Microsoft.Management/managementGroups/myMG. 
  role_definition_name = "Network Contributor" #Optional) The name of a built-in Role.
  principal_id         = data.azuread_service_principal.example.object_id # (Required) The ID of the Principal (User, Group or Service Principal) to assign the Role Definition to. 
}
#Manages a Cassandra Cluster.
resource "azurerm_cosmosdb_cassandra_cluster" "example" {
  name                           = "example-cluster" # (Required) The name which should be used for this Cassandra Cluster. 
  resource_group_name            = azurerm_resource_group.example.name #(Required) The name of the Resource Group where the Cassandra Cluster should exist
  location                       = azurerm_resource_group.example.location # (Required) The Azure Region where the Cassandra Cluster should exist.
  delegated_management_subnet_id = azurerm_subnet.example.id #(Required) The ID of the delegated management subnet for this Cassandra Cluster. Changing this forces a new Cassandra Cluster to be created.
  default_admin_password         = "Password1234" #(Required) The initial admin password for this Cassandra Cluster. Changing this forces a new resource to be created.

  depends_on = [azurerm_role_assignment.example]
}

#Manages a CosmosDB (formally DocumentDB) Account.
resource "azurerm_cosmosdb_account" "example" {
  name                = "tfex-cosmosdb-account" #(Required) Specifies the name of the CosmosDB Account.
  resource_group_name = azurerm_resource_group.example.name #(Required) The name of the resource group in which the CosmosDB Account is created. 
  location            = azurerm_resource_group.example.location # (Required) Specifies the supported Azure location where the resource exists. 
  offer_type          = "Standard" #(Required) Specifies the Offer Type to use for this CosmosDB Account; currently, this can only be set to Standard.

  capabilities { #(Optional) The capabilities which should be enabled for this Cosmos DB account.
    name = "EnableCassandra" #(Required) The capability to enable - Possible values are AllowSelfServeUpgradeToMongo36, DisableRateLimitingResponses, EnableAggregationPipeline, EnableCassandra, EnableGremlin, EnableMongo, EnableMongo16MBDocumentSupport, EnableMongoRetryableWrites, EnableMongoRoleBasedAccessControl, EnablePartialUniqueIndex, EnableServerless, EnableTable, EnableTtlOnCustomPath, EnableUniqueCompoundNestedDocs, MongoDBv3.4 and mongoEnableDocLevelTTL.
  }

  consistency_policy {
    consistency_level = "Strong" # (Required) The Consistency Level to use for this CosmosDB Account - can be either BoundedStaleness, Eventual, Session, Strong or ConsistentPrefix.
  }
#The geo_location block Configures the geographic locations the data is replicated to
  geo_location {
    location          = azurerm_resource_group.example.location
    failover_priority = 0 #(Required) The failover priority of the region. A failover priority of 0 indicates a write region. The maximum value for a failover priority = (total number of regions - 1). Failover priority values must be unique for each of the regions in which the database account exists. Changing this causes the location to be re-provisioned and cannot be changed for the location with failover priority 0.
  }
}
#Manages a Cassandra Datacenter.
resource "azurerm_cosmosdb_cassandra_datacenter" "example" {
  name                           = "example-datacenter" #(Required) The name which should be used for this Cassandra Datacenter
  location                       = azurerm_cosmosdb_cassandra_cluster.example.location #(Required) The Azure Region where the Cassandra Datacenter should exist. 
  cassandra_cluster_id           = azurerm_cosmosdb_cassandra_cluster.example.id #(Required) The ID of the Cassandra Cluster.
  delegated_management_subnet_id = azurerm_subnet.example.id # (Required) The ID of the delegated management subnet for this Cassandra Datacenter. 
  node_count                     = 3 # (Optional) The number of nodes the Cassandra Datacenter should have. The number should be equal or greater than 3. Defaults to 3.
  disk_count                     = 4 #(Optional) Determines the number of p30 disks that are attached to each node.
  sku_name                       = "Standard_DS14_v2" #(Optional) Determines the selected sku.
  availability_zones_enabled     = false # (Optional) Determines whether availability zones are enabled. Defaults to true.
}
#Manages a Cassandra KeySpace within a Cosmos DB Account.
resource "azurerm_cosmosdb_cassandra_keyspace" "example" {
  name                = "tfex-cosmos-cassandra-keyspace" #(Required) Specifies the name of the Cosmos DB Cassandra KeySpace. 
  resource_group_name = azurerm_resource_group.example.name # (Required) The name of the resource group in which the Cosmos DB Cassandra KeySpace is created.
  account_name        = azurerm_cosmosdb_account.example.name #(Required) The name of the Cosmos DB Cassandra KeySpace to create the table within. 
  throughput          = 400 #Optional) The throughput of Cassandra KeySpace (RU/s). Must be set in increments of 100. The minimum value is 400. This must be set upon database creation otherwise it cannot be updated without a manual terraform destroy-apply.
}
#Manages a Cassandra Table within a Cosmos DB Cassandra Keyspace.
resource "azurerm_cosmosdb_cassandra_table" "example" {
  name                  = "testtable" #(Required) Specifies the name of the Cosmos DB Cassandra Table.
  cassandra_keyspace_id = azurerm_cosmosdb_cassandra_keyspace.example.id # (Required) The ID of the Cosmos DB Cassandra Keyspace to create the table within. 

  schema { # A schema block as defined below.
    column { # (Required) One or more column blocks as defined below.
      name = "test1" #(Required) Name of the column to be created.
      type = "ascii" #(Required) Type of the column to be created.
    }

    column {
      name = "test2"
      type = "int"
    }

    partition_key { # (Required) One or more partition_key blocks as defined below.
      name = "test1" #(Required) Name of the column to partition by.
    }
  }
}