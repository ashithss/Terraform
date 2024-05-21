#Manages an Azure resource group.
resource "azurerm_resource_group" "rg" {
  name     = "${var.resource_group_name}" #name of the resource group
  location = "${var.location}" #location of the resource group
   tags = merge(tomap({
    Name = var.name}))
}

#Manages a Microsoft SQL Azure Database Server.
resource "azurerm_mssql_server" "sql_server" {
  name                         = "${var.name}-ss" #(Required) The name of the Microsoft SQL Server. This needs to be globally unique within Azure. Changing this forces a new resource to be created.
  resource_group_name          = "${var.resource_group_name}" #(Required) The name of the resource group in which to create the Microsoft SQL Server. Changing this forces a new resource to be created.
  location                     = "${var.location}" # (Required) Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created.
  version                      = "${var.ver}" #(Required) The version for the new server. Valid values are: 2.0 (for v11 server) and 12.0 (for v12 server). Changing this forces a new resource to be created.
  administrator_login          = "${var.administrator_login}" #(Optional) The administrator login name for the new server. Required unless azuread_authentication_only in the azuread_administrator block is true. When omitted, Azure will generate a default username which cannot be subsequently changed. Changing this forces a new resource to be created.
  administrator_login_password = "${var.administrator_login_password}" #(Optional) The password associated with the administrator_login user. Needs to comply with Azure's Password Policy. Required unless azuread_authentication_only in the azuread_administrator block is true.
   tags = merge(tomap({
    Name = var.name}))
}
#Allows you to manage an Azure SQL Firewall Rule.
resource "azurerm_mssql_firewall_rule" "fwr" {
  count               = "${length(var.rule_list)}"
  server_id         = "${azurerm_mssql_server.sql_server.id}" #(Required) The resource ID of the SQL Server on which to create the Firewall Rule. Changing this forces a new resource to be created.
  name             = "${element(split(",", element(var.rule_list, count.index)), 0)}" #(Required) name of the firewall rule.
  start_ip_address = "${element(split(",", element(var.rule_list, count.index)), 1)}" #(Required) The starting IP address to allow through the firewall for this rule.
  end_ip_address   = "${element(split(",", element(var.rule_list, count.index)), 2)}" #(Required) The ending IP address to allow through the firewall for this rule.
}


resource "azurerm_mssql_database" "sql_db" {
  name                             = "${var.name}-db" #name of the database
  server_id                      = "${azurerm_mssql_server.sql_server.id}" #server in which sql database will be created.
  create_mode                      = "Default" # (Optional) The create mode of the database. Possible values are Copy, Default, OnlineSecondary, PointInTimeRestore, Recovery, Restore, RestoreExternalBackup, RestoreExternalBackupSecondary, RestoreLongTermRetentionBackup and Secondary. Mutually exclusive with import. Changing this forces a new resource to be created.
  collation                        = "${var.collation}" # (Optional) Specifies the collation of the database. Changing this forces a new resource to be created.
   tags = merge(tomap({ #(Optional)
    Name = var.name}))
}