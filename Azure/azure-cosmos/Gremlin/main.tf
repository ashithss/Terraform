#Manages a azure resource group
resource "azurerm_resource_group" "example" {
  name     = "accexample-rg"
  location = "West Europe"
}
#Manages a virtual network including any configured subnets. Each subnet can optionally be configured with a security group to be associated with the subnet.
resource "azurerm_virtual_network" "example" {
  name                = "example-vnet"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  address_space       = ["10.0.0.0/16"] #(Required) The address space that is used the virtual network. You can supply more than one address space.
}
#Manages a subnet. Subnets represent network segments within the IP space defined by the virtual network.
resource "azurerm_subnet" "example" {
  name                 = "example-subnet" #(Required) The name of the subnet. Changing this forces a new resource to be created.
  resource_group_name  = azurerm_resource_group.example.name # (Required) The name of the resource group in which to create the subnet. 
  virtual_network_name = azurerm_virtual_network.example.name # (Required) The name of the virtual network to which to attach the subnet. 
  address_prefixes     = ["10.0.1.0/24"] #(Required) The address prefixes to use for the subnet.
}
#Manages a service principal associated with an application within Azure Active Directory.
data "azuread_service_principal" "example" {
  display_name = "Azure Cosmos DB"
}
#Assigns a given Principal (User or Group) to a given Role.
resource "azurerm_role_assignment" "example" {
  scope                = azurerm_virtual_network.example.id # (Required) The scope at which the Role Assignment applies to, such as /subscriptions/0b1f6471-1bf0-4dda-aec3-111122223333, /subscriptions/0b1f6471-1bf0-4dda-aec3-111122223333/resourceGroups/myGroup, or /subscriptions/0b1f6471-1bf0-4dda-aec3-111122223333/resourceGroups/myGroup/providers/Microsoft.Compute/virtualMachines/myVM, or /providers/Microsoft.Management/managementGroups/myMG.
  role_definition_name = "Network Contributor" #Optional) The name of a built-in Role.
  principal_id         = data.azuread_service_principal.example.object_id # (Required) The ID of the Principal (User, Group or Service Principal) to assign the Role Definition to.
}
#Manages a CosmosDB (formally DocumentDB) Account.
resource "azurerm_cosmosdb_account" "example" {
  name                = "tfex-cosmosdb-account" #(Required) Specifies the name of the CosmosDB Account.
  resource_group_name = azurerm_resource_group.example.name # (Required) The name of the resource group in which the CosmosDB Account is created.
  location            = azurerm_resource_group.example.location # (Required) Specifies the supported Azure location where the resource exists.
  offer_type          = "Standard" #(Required) Specifies the Offer Type to use for this CosmosDB Account; currently, this can only be set to Standard.

  capabilities { #(Optional) The capabilities which should be enabled for this Cosmos DB account.
    name = "EnableGremlin" #(Required) The capability to enable - Possible values are AllowSelfServeUpgradeToMongo36, DisableRateLimitingResponses, EnableAggregationPipeline, EnableCassandra, EnableGremlin, EnableMongo, EnableMongo16MBDocumentSupport, EnableMongoRetryableWrites, EnableMongoRoleBasedAccessControl, EnablePartialUniqueIndex, EnableServerless, EnableTable, EnableTtlOnCustomPath, EnableUniqueCompoundNestedDocs, MongoDBv3.4 and mongoEnableDocLevelTTL.
  }

  consistency_policy { #(Required) Specifies a consistency_policy resource, used to define the consistency policy for this CosmosDB account.
    consistency_level = "Strong" #(Required) The Consistency Level to use for this CosmosDB Account - can be either BoundedStaleness, Eventual, Session, Strong or ConsistentPrefix
  }

  geo_location { #The geo_location block Configures the geographic locations the data is replicated
    location          = azurerm_resource_group.example.location # (Required) The name of the Azure region to host replicated data.
    failover_priority = 0 #(Required) The failover priority of the region. A failover priority of 0 indicates a write region. The maximum value for a failover priority = (total number of regions - 1). Failover priority values must be unique for each of the regions in which the database account exists. Changing this causes the location to be re-provisioned and cannot be changed for the location with failover priority 0.
  }
}
#Use this data source to access information about an existing CosmosDB (formally DocumentDB) Account.
data "azurerm_cosmosdb_account" "example" {
  name                = azurerm_cosmosdb_account.example.name #Specifies the name of the CosmosDB Account.
  resource_group_name = azurerm_resource_group.example.name #Specifies the name of the resource group in which the CosmosDB Account resides.
}
#Manages a Gremlin Database within a Cosmos DB Account.
resource "azurerm_cosmosdb_gremlin_database" "example" {
  name                = "tfex-cosmos-gremlin-db" #(Required) Specifies the name of the Cosmos DB Gremlin Database.
  resource_group_name = data.azurerm_cosmosdb_account.example.resource_group_name #(Required) The name of the resource group in which the Cosmos DB Gremlin Database is created
  account_name        = data.azurerm_cosmosdb_account.example.name #(Required) The name of the CosmosDB Account to create the Gremlin Database within
  throughput          = 400 #(Optional) The throughput of the Gremlin database (RU/s). Must be set in increments of 100. The minimum value is 400. This must be set upon database creation otherwise it cannot be updated without a manual terraform destroy-apply.
  depends_on          = [azurerm_role_assignment.example]
}
#Manages a Gremlin Graph within a Cosmos DB Account.
resource "azurerm_cosmosdb_gremlin_graph" "example" {
  name                = "tfex-cosmos-gremlin-graph" # (Required) Specifies the name of the Cosmos DB Gremlin Graph.
  resource_group_name = data.azurerm_cosmosdb_account.example.resource_group_name # (Required) The name of the resource group in which the Cosmos DB Gremlin Graph is created. 
  account_name        = data.azurerm_cosmosdb_account.example.name #(Required) The name of the CosmosDB Account to create the Gremlin Graph within.
  database_name       = azurerm_cosmosdb_gremlin_database.example.name #(Required) The name of the Cosmos DB Graph Database in which the Cosmos DB Gremlin Graph is created. 
  partition_key_path  = "/Example" # (Required) Define a partition key. Changing this forces a new resource to be created.
  throughput          = 400 #(Optional) The throughput of the Gremlin graph (RU/s). Must be set in increments of 100. The minimum value is 400. This must be set upon database creation otherwise it cannot be updated without a manual terraform destroy-apply.

  index_policy {#Optional) The configuration of the indexing policy. One or more index_policy blocks as defined below.
    automatic      = true # (Optional) Indicates if the indexing policy is automatic. Defaults to true.
    indexing_mode  = "consistent" # (Required) Indicates the indexing mode. Possible values include: Consistent, Lazy, None.
    included_paths = ["/*"] # (Optional) List of paths to include in the indexing. Required if indexing_mode is Consistent or Lazy.
    excluded_paths = ["/\"_etag\"/?"] #(Optional) List of paths to exclude from indexing. Required if indexing_mode is Consistent or Lazy.
  }

  conflict_resolution_policy {
    mode                     = "LastWriterWins" #(Required) Indicates the conflict resolution mode. Possible values include: LastWriterWins, Custom.
    conflict_resolution_path = "/_ts" # (Optional) The conflict resolution path in the case of LastWriterWins mode.
  }

  unique_key {
    paths = ["/definition/id1", "/definition/id2"] # (Required) A list of paths to use for this unique key. Changing this forces a new resource to be created.
  }
}