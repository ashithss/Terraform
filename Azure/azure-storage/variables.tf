variable name {
  type        = string
  description = "(Required) The name of the resource group. Must be unique on your Azure subscription." 
}

variable location {
  type        = string
  description = "(Required) The location where the resource group should be created. For a list of all Azure locations, please consult this link: https://azure.microsoft.com/en-us/regions/"
  default     = "West Europe"
}

variable tags {
  type        = map
  description = "(Optional) A mapping of tags to assign to the resource."
  default     = {}
}

variable resource_group_name {
  type        = string
  description = "(Required) The name of the resource group in which to create the storage account. Changing this forces a new resource to be created."
}


variable account_name {
  type        = string
  description = "(Required) Specifies the name of the storage account. Changing this forces a new resource to be created. This must be unique across the entire Azure service, not just within the resource group."

}

variable account_tier {
  type        = string
  description = "(Required) Defines the Tier to use for this storage account. Valid options are Standard and Premium. Changing this forces a new resource to be created."
  default     = "Standard"
}

variable account_replication_type {
  type        = string
  description = "(Required) Defines the type of replication to use for this storage account. Valid options are LRS, GRS, RAGRS and ZRS."
  default     = "LRS"
}


variable type {
  type        = string
  description = "(Optional) The type of the storage blob to be created. One of either block or page. When not copying from an existing blob, this becomes required."
  default     = "Page"
}

variable size {
  type        = string
  description = "(Optional) Used only for page blobs to specify the size in bytes of the blob to be created. Must be a multiple of 512. Defaults to 0."
  default     = "512"
}

variable storage_container_name {
  type        = string
  description = "(Required) Specifies the name of the storage container name."
}

variable container_access_type {
  type        = string
  description = "(Required) The 'interface' for access the container provides. Can be either blob, container or private."
  default     = "private"
}

variable quota {
  type        = string
  description = "(Optional) The maximum size of the share, in gigabytes. Must be greater than 0, and less than or equal to 5 TB (5120 GB). Default this is set to 0 which results in setting the quota to 5 TB."
  default     = "1"
}