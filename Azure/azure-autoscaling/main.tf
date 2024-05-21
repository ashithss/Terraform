#Resource block to create the azure resource group
resource "azurerm_resource_group" "main" {
  name     = "${var.prefix}-resources" # (Required) The Name which should be used for this Resource Group.
  location = var.location #(Required) The Azure Region where the Resource Group should exist. 
}
#Manages a virtual network including any configured subnets. Each subnet can optionally be configured with a security group to be associated with the subnet.
resource "azurerm_virtual_network" "main" {
  name                = "${var.prefix}-network" #(Required) The name of the virtual network. Changing this forces a new resource to be created.
  address_space       = ["10.0.0.0/16"] ##(Required) The address space that is used the virtual network. You can supply more than one address space.
  location            = azurerm_resource_group.main.location  #(Required) The location/region where the virtual network is created. Changing this forces a new resource to be created.
  resource_group_name = azurerm_resource_group.main.name #(Required) The name of the resource group in which to create the virtual network. Changing this forces a new resource to be created.
}
#Use this data source to access information about an existing Subnet within a Virtual Network.
resource "azurerm_subnet" "internal" {
  name                 = "internal" # Specifies the name of the Subnet.
  resource_group_name  = azurerm_resource_group.main.name #Specifies the name of the resource group the Virtual Network is located in.
  virtual_network_name = azurerm_virtual_network.main.name #Specifies the name of the Virtual Network this Subnet is located within.
  address_prefixes     = ["10.0.2.0/24"] # The address prefixes for the subnet.
}
#Manages a Linux Virtual Machine Scale Set.
resource "azurerm_linux_virtual_machine_scale_set" "main" {
  name                            = "${var.prefix}-vmss" # (Required) The name of the Linux Virtual Machine Scale Set.
  resource_group_name             = azurerm_resource_group.main.name #Required) The name of the Resource Group in which the Linux Virtual Machine Scale Set should be exist.
  location                        = azurerm_resource_group.main.location # (Required) The Azure location where the Linux Virtual Machine Scale Set should exist. 
  sku                             = "Standard_B1s" #(Required) The Virtual Machine SKU for the Scale Set, such as Standard_F2.
  instances                       = 1 #(Optional) The number of Virtual Machines in the Scale Set. Defaults to 0.
  admin_username                  = "adminuser" #Required) The username of the local administrator on each Virtual Machine Scale Set instance. 
  admin_password                  = "P@ssw0rd1234!" #(Optional) The Password which should be used for the local-administrator on this Virtual Machine.
  disable_password_authentication = false #When an admin_password is specified disable_password_authentication must be set to false.

  source_image_reference {
    publisher = "Canonical" #(Required) Specifies the Publisher of the Extension.
    offer     = "UbuntuServer" #(Required) Specifies the offer of the image used to create the virtual machines. 
    sku       = "16.04-LTS" #(Required) Specifies the SKU of the image used to create the virtual machines.
    version   = "latest" # (Required) Specifies the version of the image used to create the virtual machines.
  } 

  network_interface { #One or more network_interface blocks
    name    = "example"
    primary = true #(Optional) Is this the Primary IP Configuration for this Network Interface? Defaults to false.

    ip_configuration { #One ip_configuration block must be marked as Primary for each Network Interface.
      name      = "internal"
      primary   = true
      subnet_id = azurerm_subnet.internal.id #(Optional) The ID of the Subnet which this IP Configuration should be connected to.
    }
  }

  os_disk {
    storage_account_type = "Standard_LRS" #(Required) The Type of Storage Account which should back this Data Disk. Possible values include Standard_LRS, StandardSSD_LRS, StandardSSD_ZRS, Premium_LRS, PremiumV2_LRS, Premium_ZRS and UltraSSD_LRS.
    caching              = "ReadWrite" # (Required) The type of Caching which should be used for this Data Disk. Possible values are None, ReadOnly and ReadWrite.
  }
}
#Manages a AutoScale Setting which can be applied to Virtual Machine Scale Sets, App Services and other scalable resources.
resource "azurerm_monitor_autoscale_setting" "main" {
  name                = "autoscale-config" # (Required) The name of the AutoScale Setting. Changing this forces a new resource to be created.
  resource_group_name = azurerm_resource_group.main.name # (Required) The name of the Resource Group in the AutoScale Setting should be created. Changing this forces a new resource to be created.
  location            = azurerm_resource_group.main.location #(Required) Specifies the supported Azure location where the AutoScale Setting should exist. Changing this forces a new resource to be created.
  target_resource_id  = azurerm_linux_virtual_machine_scale_set.main.id # (Required) Specifies the resource ID of the resource that the autoscale setting should be added to. Changing this forces a new resource to be created.

  profile {
    name = "AutoScale" #(Required) Specifies the name of the profile.

    capacity { #(Required) A capacity block as defined below.
      default = 1 #(Required) The number of instances that are available for scaling if metrics are not available for evaluation. The default is only used if the current instance count is lower than the default. Valid values are between 0 and 1000.
      minimum = 1 #(Required) The minimum number of instances for this resource. Valid values are between 0 and 1000.
      maximum = 1 #(Required) The maximum number of instances for this resource. Valid values are between 0 and 1000.
    }

    rule { #(Optional) One or more (up to 10) rule blocks 
      metric_trigger {
        metric_name        = "Percentage CPU" # (Required) The name of the metric that defines what the rule monitors, such as Percentage CPU for Virtual Machine Scale Sets and CpuPercentage for App Service Plan.
        metric_resource_id = azurerm_linux_virtual_machine_scale_set.main.id # (Required) The ID of the Resource which the Rule monitors.
        time_grain         = "PT1M" #(Required) Specifies the granularity of metrics that the rule monitors, which must be one of the pre-defined values returned from the metric definitions for the metric. This value must be between 1 minute and 12 hours an be formatted as an ISO 8601 string.
        statistic          = "Average" #(Required) Specifies how the metrics from multiple instances are combined. Possible values are Average, Max, Min and Sum.
        time_window        = "PT5M" #(Required) Specifies the time range for which data is collected, which must be greater than the delay in metric collection (which varies from resource to resource). This value must be between 5 minutes and 12 hours and be formatted as an ISO 8601 string.
        time_aggregation   = "Average" #(Required) Specifies how the data that's collected should be combined over time. Possible values include Average, Count, Maximum, Minimum, Last and Total.
        operator           = "GreaterThan" #(Required) Specifies the operator used to compare the metric data and threshold. Possible values are: Equals, NotEquals, GreaterThan, GreaterThanOrEqual, LessThan, LessThanOrEqual.
        threshold          = 75 # (Required) Specifies the threshold of the metric that triggers the scale action.
      }

      scale_action {
        direction = "Increase" #(Required) The scale direction. Possible values are Increase and Decrease.
        type      = "ChangeCount" ##(Required) The type of action that should occur. Possible values are ChangeCount, ExactCount, PercentChangeCount and ServiceAllowedNextValue.
        value     = "1"  # (Required) The number of instances involved in the scaling action.
        cooldown  = "PT1M" #(Required) The amount of time to wait since the last scaling action before this action occurs. Must be between 1 minute and 1 week and formatted as a ISO 8601 string.
      }
    }

    rule {
      metric_trigger {
        metric_name        = "Percentage CPU" # (Required) The name of the metric that defines what the rule monitors, such as Percentage CPU for Virtual Machine Scale Sets and CpuPercentage for App Service Plan.
        metric_resource_id = azurerm_linux_virtual_machine_scale_set.main.id # (Required) The ID of the Resource which the Rule monitors.
        time_grain         = "PT1M" #(Required) Specifies the granularity of metrics that the rule monitors, which must be one of the pre-defined values returned from the metric definitions for the metric. This value must be between 1 minute and 12 hours an be formatted as an ISO 8601 string.
        statistic          = "Average" #(Required) Specifies how the metrics from multiple instances are combined. Possible values are Average, Max, Min and Sum.
        time_window        = "PT5M" # (Required) Specifies the time range for which data is collected, which must be greater than the delay in metric collection (which varies from resource to resource). This value must be between 5 minutes and 12 hours and be formatted as an ISO 8601 string.
        time_aggregation   = "Average" # (Required) Specifies how the data that's collected should be combined over time. Possible values include Average, Count, Maximum, Minimum, Last and Total.
        operator           = "LessThan" #(Required) Specifies the operator used to compare the metric data and threshold. Possible values are: Equals, NotEquals, GreaterThan, GreaterThanOrEqual, LessThan, LessThanOrEqual.
        threshold          = 25 #(Required) Specifies the threshold of the metric that triggers the scale action.
      }

      scale_action {
        direction = "Decrease" #(Required) The scale direction. Possible values are Increase and Decrease.
        type      = "ChangeCount" #(Required) The type of action that should occur. Possible values are ChangeCount, ExactCount, PercentChangeCount and ServiceAllowedNextValue.
        value     = "1" # (Required) The number of instances involved in the scaling action.
        cooldown  = "PT1M" #(Required) The amount of time to wait since the last scaling action before this action occurs. Must be between 1 minute and 1 week and formatted as a ISO 8601 string.
      }
    }
  }
}