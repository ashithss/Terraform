# General Settings
variable "resource_group_name" {
  type        = string
  description = "(Required) The name of the resource group in which to create the virtual network."
}

variable "name" {
  type        = string
  description = "(Required) The prefix for name of virtual network, network security group, public IPs and network interfaces. Changing this forces new resources to be created."
}

variable "location" {
  type        = string
  description = "(Required) The location/region where the virtual network is created. Changing this forces a new resource to be created. For a list of all Azure locations, please consult this link: https://azure.microsoft.com/en-us/regions/"
  default     = "West Europe"
}


variable "virtual_network_tags" {
  type        = map(any)
  description = "(Optional) A mapping of tags to assign to the resource."
  default     = {}
}


#Security Group Specific Settings
# Passed in a as a list of comma deliniated string lists in the format 
# ["name,priority,direction,access,protocol,source_port_range,destination_port_range,source_address_prefix,destination_address_prefix", ...]
variable "rule_list" {
  type        = list(any)
  description = "(Optional) Network security rules as list"
  default     = []
}

variable "security_group_tags" {
  type        = map(any)
  description = "(Optional) A mapping of tags to assign to the resource."
  default     = {}
}

#Network Interface Specific Settings
variable "cou" {
  type        = string
  description = "(Required) Number of network interfaces per VM."
  default     = "1"
}

variable "count_offset" {
  type        = string
  description = "(Optional) Start network interface numbering from this value. If you set it to 100, servers will be numbered -101, 102,..."
  default     = "0"
}

variable "count_format" {
  type        = string
  description = "(Optional) network interface numbering format (-01, -02, etc.) in printf format"
  default     = "%d"
}

variable "lb_pool_ids" {
  type        = list(any)
  description = "(Optional) Load balancer pool ids"
  default     = [""]
}

variable "network_interface_tags" {
  type        = map(any)
  description = "(Optional) A mapping of tags to assign to the resource."
  default     = {}
}

variable "network_interface_subnet_name" {
  type        = string
  description = ""
  default     = "default"
}

variable "private_ip_address_allocation" {
  type        = string
  description = "(Optional) IP assignment for the network interface. Can be static or dynamic: if using static please set private_ip_address"
  default     = "Dynamic"
}

variable "public_ip_address_allocation" {
  type        = string
  description = "(Required) Defines whether the IP address is stable or dynamic. Options are Static or Dynamic."
  default     = "dynamic"
}

#Public IP Specific Settings
variable "public_ip_tags" {
  type        = map(any)
  description = "(Optional) A mapping of tags to assign to the resource."
  default     = {}
}