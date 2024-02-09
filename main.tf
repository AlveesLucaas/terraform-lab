#------------------------------------------------------------------------------
####Define o provedor Azure
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.73.0"
    }
  }
}

provider "azurerm" {
  features {}
}

#------------------------------------------------------------------------------

#### Cria o grupo de recursos
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

#------------------------------------------------------------------------------

#### Cria a interface de rede com IP interno somente (referenciar a subnet desejada)
resource "azurerm_network_interface" "internal-nic" {
  name                = var.network_interface_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = var.tags

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

# Associa o grupo de segurança de rede existente à interface de rede da VM
resource "azurerm_network_interface_security_group_association" "nsg" {
  network_interface_id      = azurerm_network_interface.internal-nic.id
  network_security_group_id = var.network_security_group_id
}

#------------------------------------------------------------------------------

#### Cria uma chave SSH
resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

#### Salva a chave privada em um arquivo
resource "local_file" "ssh_private_key" {
  filename = "${path.module}/id_rsa"
  content  = tls_private_key.ssh_key.private_key_pem
}

#------------------------------------------------------------------------------

#### Cria a VM
resource "azurerm_linux_virtual_machine" "vm" {
  name                = var.virtual_machine_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = var.vm_size
  admin_username      = var.admin_username
  tags                = var.tags
  network_interface_ids = [
    azurerm_network_interface.internal-nic.id,
  ]

  admin_ssh_key {
    username   = var.admin_username
    public_key = tls_private_key.ssh_key.public_key_openssh
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}

#------------------------------------------------------------------------------

#### Cria um disco gerenciado para ser attachado ao servidor
resource "azurerm_managed_disk" "storage-disk" {
  name                 = var.managed_disk_name
  location             = var.location
  resource_group_name  = azurerm_resource_group.rg.name
  storage_account_type = "StandardSSD_LRS"
  create_option        = "Empty"
  disk_size_gb         = 256
  tags                 = var.tags
}

#### Attacha o disco criado a VM
resource "azurerm_virtual_machine_data_disk_attachment" "disk-attach" {
  managed_disk_id    = azurerm_managed_disk.storage-disk.id
  virtual_machine_id = azurerm_linux_virtual_machine.vm.id
  lun                = "0"
  caching            = "ReadWrite"
}

#------------------------------------------------------------------------------

#### Habilita o Azure Monitor
resource "azurerm_monitor_diagnostic_setting" "azure-monitor" {
  name                       = "DiagnosticSettingForVM"
  target_resource_id         = azurerm_linux_virtual_machine.vm.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  log {
    category = "AllMetrics"
    enabled  = true

    retention_policy {
      enabled = true
      days    = 30
    }
  }
}
