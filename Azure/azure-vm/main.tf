# Resource block to create the azure resource group
resource "azurerm_resource_group" "rg" {
  name     = "${var.resource_group_name}-rg" #name of the resource group
  location = var.location #location of the resource group
  tags = merge(tomap({  #(Optional)key and pair value
  Name = var.name }))
}

# Resource block to create the azure virtual network 
resource "azurerm_virtual_network" "vnn" {
  name                = "example-network" #name of the virtual network
  address_space       = ["10.0.0.0/16"] #When you create a VNet, you first need to specify a private IP address space
  location            = azurerm_resource_group.rg.location #location of the virtual network
  resource_group_name = azurerm_resource_group.rg.name# name of the resource group for virtual network
}
## Resource block to create the azure subnet group
resource "azurerm_subnet" "sub" {
  name                 = "internal" #name of the subnet
  resource_group_name  = azurerm_resource_group.rg.name #name of the subnet.
  virtual_network_name = azurerm_virtual_network.vnn.name #name of the virtual network in which subnet will be placed.
  address_prefixes     = ["10.0.2.0/24"] #Subnets are smaller segmentations of the virtual network.
}
# Public IP for Virtual Machine
resource "azurerm_public_ip" "public_ip" {
  name                = "vm_public_ip" #name of the public ip
  resource_group_name = azurerm_resource_group.rg.name #resource group of the ip
  location            = azurerm_resource_group.rg.location #location of the public ip
  allocation_method   = "Dynamic"  # (Required) Defines the allocation method for this IP address. Possible values are Static or Dynamic.
}

#Manages a Network Interface.
resource "azurerm_network_interface" "nic" {
  name                = "example-nic" #name of the network interface.
  location            = azurerm_resource_group.rg.location #location of the network interface
  resource_group_name = azurerm_resource_group.rg.name #resource group for network interface.
  ip_configuration { #(Required) One or more ip_configuration blocks as defined below.
    name                          = "internal"
    subnet_id                     = azurerm_subnet.sub.id #(Optional) The ID of the Subnet where this Network Interface should be located in.
    private_ip_address_allocation = "Dynamic" #(Required) The allocation method used for the Private IP Address. Possible values are Dynamic and Static
    public_ip_address_id          = azurerm_public_ip.public_ip.id #(Optional) Reference to a Public IP Address to associate with this NIC
  }
}
#Manages a network security group that contains a list of network security rules. Network security groups enable inbound or outbound traffic to be enabled or denied.
resource "azurerm_network_security_group" "nsg" {
  name                = "ssh_nsg" #name of the network security group
  location            = azurerm_resource_group.rg.location #location of the network security group
  resource_group_name = azurerm_resource_group.rg.name#resource group name of the network security group

  security_rule { #rules blocck
    name                       = "allow_ssh_sg" #name of the rule.
    priority                   = 100 #(Required) Specifies the priority of the rule. The value can be between 100 and 4096. The priority number must be unique for each rule in the collection. The lower the priority number, the higher the priority of the rule.
    direction                  = "Inbound" # (Required) The direction specifies if rule will be evaluated on incoming or outgoing traffic. Possible values are Inbound and Outbound.
    access                     = "Allow" # (Required) Specifies whether network traffic is allowed or denied. Possible values are Allow and Deny.
    protocol                   = "Tcp" # (Required) Network protocol this rule applies to. Possible values include Tcp, Udp, Icmp, Esp, Ah or * (which matches all).
    source_port_range          = "*" # (Optional) Source Port or Range. Integer or range between 0 and 65535 or * to match any. This is required if source_port_ranges is not specified.
    destination_port_range     = "22" #(Optional) Destination Port or Range. Integer or range between 0 and 65535 or * to match any. This is required if destination_port_ranges is not specified.
    source_address_prefix      = "*" #(Optional) CIDR or source IP range or * to match any IP. Tags such as VirtualNetwork, AzureLoadBalancer and Internet can also be used. This is required if source_address_prefixes is not specified.
    destination_address_prefix = "*" # (Optional) CIDR or destination IP range or * to match any IP. Tags such as VirtualNetwork, AzureLoadBalancer and Internet can also be used. This is required if destination_address_prefixes is not specified.
  }
}
#Manages the association between a Network Interface and a Network Security Group.
resource "azurerm_network_interface_security_group_association" "association" {
  network_interface_id      = azurerm_network_interface.nic.id #(Required) The ID of the Network Interface. Changing this forces a new resource to be created.
  network_security_group_id = azurerm_network_security_group.nsg.id #(Required) The ID of the Network Security Group which should be attached to the Network Interface. Changing this forces a new resource to be created.
}


#Manages an Azure Storage Account.
resource "azurerm_storage_account" "sa" {
  name                     = "examplestoraccount123321" #name of the storage account
  resource_group_name      = azurerm_resource_group.rg.name#name of the resource group for storage account
  location                 = azurerm_resource_group.rg.location#azure region for resource storage account
  account_tier             = "Standard" #(Required) Defines the Tier to use for this storage account. Valid options are Standard and Premium. For BlockBlobStorage and FileStorage accounts only Premium is valid. Changing this forces a new resource to be created.
  account_replication_type = "LRS" #account_replication_type - (Required) Defines the type of replication to use for this storage account. Valid options are LRS, GRS, RAGRS, ZRS, GZRS and RAGZRS.
  tags = {
    environment = "staging"
  }
}


#Manages a Container within an Azure Storage Account.
resource "azurerm_storage_container" "osdisk" {
  count                 = var.cou
  name                  = "${var.name}-${format(var.count_format, var.count_offset + count.index + 1)}" #name of the container
  storage_account_name  = azurerm_storage_account.sa.name #name of the storage account in which container will be created.
  container_access_type = "private" #(Optional) The Access Level configured for this Container. Possible values are blob, container or private. Defaults to private.
}


#Manages a SSH Public Key.
resource "azurerm_ssh_public_key" "sshname" {
  name                = "sshfile" #(Required) The name which should be used for this SSH Public Key. Changing this forces a new SSH Public Key to be created.
  resource_group_name = azurerm_resource_group.rg.name #(Required) The name of the Resource Group where the SSH Public Key should exist. Changing this forces a new SSH Public Key to be created.
  location            = azurerm_resource_group.rg.location #(Required) The Azure Region where the SSH Public Key should exist. Changing this forces a new SSH Public Key to be created.
  public_key          = file("C:/Users/arti.jain/.ssh/id_rsa.pub")  #(Required) SSH public key used to authenticate to a virtual machine through ssh. the provided public key needs to be at least 2048-bit and in ssh-rsa format.
}

resource "azurerm_virtual_machine" "vm" {
  count                 = var.cou
  name                  = "${var.name}-vm-${format(var.count_format, var.count_offset + count.index + 1)}" #(Required) Specifies the name of the Virtual Machine. Changing this forces a new resource to be created.
  location              = var.location # (Required) Specifies the Azure Region where the Virtual Machine exists. 
  resource_group_name   = "${var.resource_group_name}-rg" # (Required) Specifies the name of the Resource Group in which the Virtual Machine should exist. Changing this forces a new resource to be created.
  vm_size               = var.vm_size #(Required) Specifies the size of the Virtual Machine
  # Uncomment this line to delete the OS disk automatically when deleting the VM
  # delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  # delete_data_disks_on_termination = true
  network_interface_ids = ["${element(["${azurerm_network_interface.nic.id}"], count.index)}"] #(Required) A list of Network Interface IDs which should be associated with the Virtual Machine.
  availability_set_id   = var.availability_set_id # (Optional) The ID of the Availability Set in which the Virtual Machine should exist. Changing this forces a new resource to be created.
  #This block provisions the Virtual Machine from one of two sources: an Azure Platform Image (e.g. Ubuntu/Windows Server) or a Custom Image.
  storage_image_reference {
    publisher = var.image_publisher #(Optional) Specifies the publisher of the image used to create the virtual machine
    offer     = var.image_offer #(Optional) Specifies the offer of the image used to create the virtual machine. C
    sku       = var.image_sku # (Optional) Specifies the SKU of the image used to create the virtual machine. 
    version   = var.image_version # (Optional) Specifies the version of the image used to create the virtual machine.
  }

  storage_os_disk {
    name          = "${var.name}-${format(var.count_format, var.count_offset + count.index + 1)}" #(Required) Specifies the name of the OS Disk.
    vhd_uri       = "https://${azurerm_storage_account.sa.name}.blob.core.windows.net/${element(azurerm_storage_container.osdisk.*.name, count.index)}/${var.os_disk_name}.vhd" #(Optional) Specifies the URI of the VHD file backing this Unmanaged OS Disk.
    caching       = "ReadWrite" # (Optional) Specifies the caching requirements for the OS Disk. Possible values include None, ReadOnly and ReadWrite.
    create_option = "FromImage" # (Required) Specifies how the OS Disk should be created. Possible values are Attach (managed disks only) and FromImage.
  }
# (Optional) An os_profile block as defined below. Required when create_option in the storage_os_disk block is set to FromImage.
  os_profile {
    computer_name  = "${var.name}-${format(var.count_format, var.count_offset + count.index + 1)}" #Required) Specifies the name of the Virtual Machine. Changing this forces a new resource to be created.
    admin_username = var.admin_username #(Required) Specifies the name of the local administrator account.
    custom_data    = length(var.cloud_init_rendered) == "1" ? element(var.cloud_init_rendered, 1) : element(var.cloud_init_rendered, count.index) #(Optional) Specifies custom data to supply to the machine. On Linux-based systems, this can be used as a cloud-init script. On other systems, this will be copied as a file on disk. Internally, Terraform will base64 encode this value before sending it to the API. The maximum length of the binary array is 65535 bytes. Changing this forces a new resource to be created.
  }
  # (Optional) (Required, when a Linux machine) An os_profile_linux_config block as defined below.
  os_profile_linux_config {
    disable_password_authentication = true #(Required) Specifies whether password authentication should be disabled. If set to false, an admin_password must be specified.

    ssh_keys { # (Optional) One or more ssh_keys blocks as defined below. This field is required if disable_password_authentication is set to true.
      path     = "/home/${var.admin_username}/.ssh/authorized_keys" # (Required) The path of the destination file on the virtual machine
      key_data = azurerm_ssh_public_key.sshname.public_key # (Required) The Public SSH Key which should be written to the path defined above.
    }
  }

  boot_diagnostics {
    enabled     = true #(Required) Should Boot Diagnostics be enabled for this Virtual Machine?
    storage_uri = "https://${azurerm_storage_account.sa.name}.blob.core.windows.net" #Required) The Storage Account's Blob Endpoint which should hold the virtual machine's diagnostic files
  }
  tags = merge(tomap({
  Name = var.name }))
}

