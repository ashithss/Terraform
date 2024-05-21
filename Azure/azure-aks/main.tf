#Resource block to create the azure resource group
resource "azurerm_resource_group" "example" {
  name     = "${var.prefix}-k8s-resources" # (Required) The Name which should be used for this Resource Group.
  location = var.location #(Required) The Azure Region where the Resource Group should exist. 
}
#Manages a Managed Kubernetes Cluster (also known as AKS / Azure Kubernetes Service)
resource "azurerm_kubernetes_cluster" "example" {
  name                = "${var.prefix}-k8s" # (Required) The name of the Managed Kubernetes Cluster to create. Changing this forces a new resource to be created.
  location            = azurerm_resource_group.example.location #Required) The location where the Managed Kubernetes Cluster should be created. Changing this forces a new resource to be created.
  resource_group_name = azurerm_resource_group.example.name #(Required) Specifies the Resource Group where the Managed Kubernetes Cluster should exist. Changing this forces a new resource to be created.
  dns_prefix          = "${var.prefix}-k8s" #(Optional) DNS prefix specified when creating the managed cluster. Possible values must begin and end with a letter or number, contain only letters, numbers, and hyphens and be between 1 and 54 characters in length.

  default_node_pool { # (Required) A default_node_pool block as defined below.
    name       = "default"
    node_count = 1 # (Optional) The initial number of nodes which should exist in this Node Pool. If specified this must be between 1 and 1000 and between min_count and max_count.
    vm_size    = "Standard_DS2_v2" # (Required) The size of the Virtual Machine, such as Standard_DS2_v2. temporary_name_for_rotation must be specified when attempting a resize.
  }

  identity { #In addition, one of either identity or service_principal blocks must be specified.
    type = "SystemAssigned"
  }
}