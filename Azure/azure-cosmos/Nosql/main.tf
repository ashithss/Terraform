#Manages a azure resource group
resource "azurerm_resource_group" "example" {
  name     = "accexample-rg"
  location = "West Europe"
}
#Manages a virtual network including any configured subnets. Each subnet can optionally be configured with a security group to be associated with the subnet.
resource "azurerm_virtual_network" "example" {
  name                = "example-vnet" # (Required) The name of the virtual network. Changing this forces a new resource to be created.
  location            = azurerm_resource_group.example.location # (Required) The location/region where the virtual network is created. 
  resource_group_name = azurerm_resource_group.example.name # (Required) The name of the resource group in which to create the virtual network. Changing this forces a new resource to be created.
  address_space       = ["10.0.0.0/16"] #(Required) The address space that is used the virtual network. You can supply more than one address space.
}
#Manages a subnet. Subnets represent network segments within the IP space defined by the virtual network.
resource "azurerm_subnet" "example" {
  name                 = "example-subnet" #(Required) The name of the subnet. Changing this forces a new resource to be created.
  resource_group_name  = azurerm_resource_group.example.name #(Required) The name of the resource group in which to create the subnet. 
  virtual_network_name = azurerm_virtual_network.example.name #(Required) The name of the virtual network to which to attach the subnet. Changing this forces a new resource to be created.
  address_prefixes     = ["10.0.1.0/24"] #(Required) The address prefixes to use for the subnet.
}
#Manages a service principal associated with an application within Azure Active Directory.
data "azuread_service_principal" "example" {
  display_name = "Azure Cosmos DB"
}
#Assigns a given Principal (User or Group) to a given Role.
resource "azurerm_role_assignment" "example" {
  scope                = azurerm_virtual_network.example.id # (Required) The scope at which the Role Assignment applies to, such as /subscriptions/0b1f6471-1bf0-4dda-aec3-111122223333, /subscriptions/0b1f6471-1bf0-4dda-aec3-111122223333/resourceGroups/myGroup, or /subscriptions/0b1f6471-1bf0-4dda-aec3-111122223333/resourceGroups/myGroup/providers/Microsoft.Compute/virtualMachines/myVM, or /providers/Microsoft.Management/managementGroups/myMG. Changing this forces a new resource to be created.
  role_definition_name = "Network Contributor" #Optional) The name of a built-in Role.
  principal_id         = data.azuread_service_principal.example.object_id #(Required) The ID of the Principal (User, Group or Service Principal) to assign the Role Definition to. Changing this forces a new resource to be created.
}
#Manages a CosmosDB (formally DocumentDB) Account.
resource "azurerm_cosmosdb_account" "example" {
  name                = "tfex-cosmosdb-account" # (Required) Specifies the name of the CosmosDB Account. Changing this forces a new resource to be created.
  resource_group_name = azurerm_resource_group.example.name #(Required) The name of the resource group in which the CosmosDB Account is created. Changing this forces a new resource to be created.
  location            = azurerm_resource_group.example.location #(Required) Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created.
  offer_type          = "Standard" # (Required) Specifies the Offer Type to use for this CosmosDB Account; currently, this can only be set to Standard.
  kind                = "GlobalDocumentDB" #(Optional) Specifies the Kind of CosmosDB to create - possible values are GlobalDocumentDB, MongoDB and Parse. Defaults to GlobalDocumentDB. Changing this forces a new resource to be created.

  consistency_policy { #(Required) Specifies a consistency_policy resource, used to define the consistency policy for this CosmosDB account.
    consistency_level = "Strong" # (Required) The Consistency Level to use for this CosmosDB Account - can be either BoundedStaleness, Eventual, Session, Strong or ConsistentPrefix.
  }

  geo_location {
    location          = azurerm_resource_group.example.location #(Required) The name of the Azure region to host replicated data.
    failover_priority = 0 # (Required) The failover priority of the region. A failover priority of 0 indicates a write region. The maximum value for a failover priority = (total number of regions - 1). Failover priority values must be unique for each of the regions in which the database account exists. Changing this causes the location to be re-provisioned and cannot be changed for the location with failover priority 0.
  }
}
#Use this data source to access information about an existing CosmosDB (formally DocumentDB) Account.
data "azurerm_cosmosdb_account" "example" {
  name                = azurerm_cosmosdb_account.example.name #Specifies the name of the CosmosDB Account.
  resource_group_name = azurerm_resource_group.example.name # Specifies the name of the resource group in which the CosmosDB Account resides.
}
#Manages a SQL Database within a Cosmos DB Account.
resource "azurerm_cosmosdb_sql_database" "example" {
  name                = "example-acsd" #(Required) Specifies the name of the Cosmos DB SQL Database. Changing this forces a new resource to be created.
  resource_group_name = data.azurerm_cosmosdb_account.example.resource_group_name #(Required) The name of the resource group in which the Cosmos DB SQL Database is created. Changing this forces a new resource to be created.
  account_name        = data.azurerm_cosmosdb_account.example.name # (Required) The name of the Cosmos DB SQL Database to create the table within. Changing this forces a new resource to be created.
}
#Manages a SQL Container within a Cosmos DB Account.
resource "azurerm_cosmosdb_sql_container" "example" {
  name                  = "example-container" #(Required) Specifies the name of the Cosmos DB SQL Container. Changing this forces a new resource to be created.
  resource_group_name   = data.azurerm_cosmosdb_account.example.resource_group_name # (Required) The name of the resource group in which the Cosmos DB SQL Container is created. Changing this forces a new resource to be created.
  account_name          = data.azurerm_cosmosdb_account.example.name # (Required) The name of the Cosmos DB Account to create the container within. Changing this forces a new resource to be created.
  database_name         = azurerm_cosmosdb_sql_database.example.name # (Required) The name of the Cosmos DB SQL Database to create the container within. Changing this forces a new resource to be created.
  partition_key_path    = "/definition/id" #(Required) Define a partition key. Changing this forces a new resource to be created.
  partition_key_version = 1 #(Optional) Define a partition key version. Changing this forces a new resource to be created. Possible values are 1and 2. This should be set to 2 in order to use large partition keys.
  throughput            = 400 # (Optional) The throughput of SQL container (RU/s). Must be set in increments of 100. The minimum value is 400. This must be set upon container creation otherwise it cannot be updated without a manual terraform destroy-apply.

  indexing_policy {
    indexing_mode = "consistent" #(Optional) Indicates the indexing mode. Possible values include: consistent and none. Defaults to consistent.

    included_path { # (Optional) One or more included_path blocks as defined below. Either included_path or excluded_path must contain the path /*
      path = "/*"
    }

    included_path {
      path = "/included/?"
    }

    excluded_path { #(Optional) One or more excluded_path blocks as defined below. Either included_path or excluded_path must contain the path /*
      path = "/excluded/?"
    }
  }

  unique_key {
    paths = ["/definition/idlong", "/definition/idshort"] # (Required) A list of paths to use for this unique key. Changing this forces a new resource to be created.
  }
}

#Manages an SQL User Defined Function.
resource "azurerm_cosmosdb_sql_function" "example" {
  name         = "test-function" # (Required) The name which should be used for this SQL User Defined Function. Changing this forces a new SQL User Defined Function to be created.
  container_id = azurerm_cosmosdb_sql_container.example.id # (Required) The id of the Cosmos DB SQL Container to create the SQL User Defined Function within. Changing this forces a new SQL User Defined Function to be created.
  body         = "function trigger(){}" #(Required) Body of the User Defined Function.
}
#Manages an SQL Trigger.
resource "azurerm_cosmosdb_sql_trigger" "example" {
  name         = "test-trigger" # (Required) The name which should be used for this SQL Trigger. Changing this forces a new SQL Trigger to be created
  container_id = azurerm_cosmosdb_sql_container.example.id #(Required) The id of the Cosmos DB SQL Container to create the SQL Trigger within. Changing this forces a new SQL Trigger to be created.
  body         = "function trigger(){}" #(Required) Body of the Trigger.
  operation    = "Delete" #(Required) The operation the trigger is associated with. Possible values are All, Create, Update, Delete and Replace.
  type         = "Post" # (Required) Type of the Trigger. Possible values are Pre and Post.
}
#Manages a SQL Stored Procedure within a Cosmos DB Account SQL Database.
resource "azurerm_cosmosdb_sql_stored_procedure" "example" {
  name                = "test-stored-proc" #(Required) Specifies the name of the Cosmos DB SQL Stored Procedure. Changing this forces a new resource to be created.
  resource_group_name = data.azurerm_cosmosdb_account.example.resource_group_name #(Required) The name of the resource group in which the Cosmos DB SQL Database is created. Changing this forces a new resource to be created.
  account_name        = data.azurerm_cosmosdb_account.example.name #(Required) The name of the Cosmos DB Account to create the stored procedure within. Changing this forces a new resource to be created.
  database_name       = azurerm_cosmosdb_sql_database.example.name # (Required) The name of the Cosmos DB SQL Database to create the stored procedure within. Changing this forces a new resource to be created.
  container_name      = azurerm_cosmosdb_sql_container.example.name # (Required) The name of the Cosmos DB SQL Container to create the stored procedure within. Changing this forces a new resource to be created.
#(Required) The body of the stored procedure.
  body = <<BODY
   function () { var context = getContext(); var response = context.getResponse(); response.setBody('Hello, World'); }
BODY
}