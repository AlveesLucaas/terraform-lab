variable "resource_group_name" {
  description = "The name of the resource group."
  type        = string
}

variable "location" {
  description = "The Azure region where the resources should be created."
  type        = string
}

variable "tags" {
  description = "Tags to be applied to all Azure resources."
  type        = map(string)
}

variable "network_interface_name" {
  description = "Name of the network interface."
  type        = string
}

variable "subnet_id" {
  description = "ID of the subnet."
  type        = string
}

variable "network_security_group_id" {
  description = "ID of the network security group."
  type        = string
}

variable "virtual_machine_name" {
  description = "Name of the virtual machine."
  type        = string
}

variable "vm_size" {
  description = "Size of the virtual machine."
  type        = string
}

variable "admin_username" {
  description = "Username for SSH access."
  type        = string
}

variable "managed_disk_name" {
  description = "Name of the managed disk."
  type        = string
}

variable "log_analytics_workspace_id" {
  description = "ID of the Log Analytics workspace."
  type        = string
}
