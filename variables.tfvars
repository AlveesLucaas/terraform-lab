resource_group_name = "GRPRD-BMGSEG-DEVOPSTOOLS"
location            = "Brazil South"
tags = {
  ENV         = "PRD"
  Application = "Elastic Search"
}
network_interface_name     = "INTERNAL-NIC-VML-DEVOPS-TOOLS-PRD"
subnet_id                  = "/subscriptions/56dfde38-0ae3-49a8-9fec-37a8c1bb2087/resourceGroups/GRPRD-BMGSEG/providers/Microsoft.Network/virtualNetworks/VNET-GRPRD-BMGSEG/subnets/Subnet-Producao"
network_security_group_id  = "/subscriptions/56dfde38-0ae3-49a8-9fec-37a8c1bb2087/resourceGroups/GRPRD-BMGSEG/providers/Microsoft.Network/networkSecurityGroups/NSG-GRPRD-BMGSEG"
virtual_machine_name       = "VML-DEVOPS-TOOLS-PRD"
vm_size                    = "standard_d4as_v5"
admin_username             = "adminuser"
managed_disk_name          = "VML-DEVOPS-TOOLS-PRD-STG-DISK-1"
log_analytics_workspace_id = "/subscriptions/56dfde38-0ae3-49a8-9fec-37a8c1bb2087/resourceGroups/BMG-RG-MONITOR/providers/Microsoft.OperationalInsights/workspaces/LA-BMG-MONITOR"
