terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "c63a85fa-9eaa-4faf-b131-af74bb2c7725"
}

# 1. Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "agriprice-rg"
  location = "spaincentral"
}

# 2. Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = "agriprice-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# 3. Public Subnet
resource "azurerm_subnet" "public_subnet" {
  name                 = "public-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
  depends_on           = [azurerm_virtual_network.vnet]
}

# 4. Private Subnet
resource "azurerm_subnet" "private_subnet" {
  name                 = "private-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.2.0/24"]
  depends_on           = [azurerm_virtual_network.vnet]
}

# 5. Network Security Groups
resource "azurerm_network_security_group" "bastion_nsg" {
  name                = "bastion-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "SSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = var.my_ip
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_security_group" "app_nsg" {
  name                = "app-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "SSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "10.0.1.0/24"
    destination_address_prefix = "*"
  }
  
  security_rule {
    name                       = "HTTP"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "5000"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Associate NSGs with Subnets (Fixes CKV2_AZURE_31)
resource "azurerm_subnet_network_security_group_association" "public" {
  subnet_id                 = azurerm_subnet.public_subnet.id
  network_security_group_id = azurerm_network_security_group.bastion_nsg.id
}

resource "azurerm_subnet_network_security_group_association" "private" {
  subnet_id                 = azurerm_subnet.private_subnet.id
  network_security_group_id = azurerm_network_security_group.app_nsg.id
}

# 6. Public IPs
resource "azurerm_public_ip" "bastion_ip" {
  name                = "bastion-ip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# 7. Network Interfaces
# checkov:skip=CKV_AZURE_119: Bastion host requires a public IP for SSH access as per assignment requirements
resource "azurerm_network_interface" "bastion_nic" {
  name                = "bastion-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.public_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.bastion_ip.id
  }
}

resource "azurerm_network_interface" "app_nic" {
  name                = "app-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.private_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

# 8. Virtual Machines
resource "azurerm_linux_virtual_machine" "bastion_vm" {
  name                = "bastion-vm"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_B2ts_v2"
  admin_username      = "ubuntu"
  network_interface_ids = [azurerm_network_interface.bastion_nic.id]

  allow_extension_operations = false

  admin_ssh_key {
    username   = "ubuntu"
    public_key = file("./azure-key.pub")
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

resource "azurerm_linux_virtual_machine" "app_vm" {
  name                = "app-vm"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_B2ts_v2"
  admin_username      = "ubuntu"
  network_interface_ids = [azurerm_network_interface.app_nic.id]

  allow_extension_operations = false

  admin_ssh_key {
    username   = "ubuntu"
    public_key = file("./azure-key.pub")
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

# 9. Container Registry
resource "azurerm_container_registry" "acr" {
  name                = "agripriceacr"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  
  sku                 = "Premium" 
  
  # Fix: Disabled Admin Account (CKV_AZURE_137)
  admin_enabled       = false 
  
  zone_redundancy_enabled = true
  data_endpoint_enabled   = true

  retention_policy {
    days    = 7
    enabled = true
  }

  # Suppressing enterprise-only features for this student project
  # checkov:skip=CKV_AZURE_164: Content trust is not required for this scope
  # checkov:skip=CKV_AZURE_139: Private link requires extra DNS setup out of scope
  # checkov:skip=CKV_AZURE_165: Geo-replication out of scope
  # checkov:skip=CKV_AZURE_166: Quarantine policy out of scope
}

# 10. Database
resource "azurerm_postgresql_flexible_server" "db" {
  name                   = "agriprice-db-server"
  resource_group_name    = azurerm_resource_group.rg.name
  location               = azurerm_resource_group.rg.location
  version                = "13"
  administrator_login    = "postgres"
  administrator_password = var.db_password
  storage_mb             = 32768
  sku_name               = "GP_Standard_D2ds_v4"
  zone                   = "1"
  
  # Fixes CKV_AZURE_136
  geo_redundant_backup_enabled = true

  # checkov:skip=CKV2_AZURE_57: Private endpoint requires complex private DNS setup out of scope for this project
}

# 11. Database Firewall Rule
resource "azurerm_postgresql_flexible_server_firewall_rule" "db_firewall" {
  name             = "AllowPrivateSubnet"
  server_id        = azurerm_postgresql_flexible_server.db.id
  start_ip_address = "10.0.2.0"
  end_ip_address   = "10.0.2.255"
}

# 12. Outputs
output "bastion_public_ip" { value = azurerm_public_ip.bastion_ip.ip_address }
output "app_private_ip" { value = azurerm_network_interface.app_nic.private_ip_address }
output "acr_url" { value = azurerm_container_registry.acr.login_server }
output "db_endpoint" { value = azurerm_postgresql_flexible_server.db.fqdn }