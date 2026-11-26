variable "rg_name" { type = string }
variable "location" { type = string }
variable "vnet_name" { type = string }
variable "address_space" { type = list(string) }
variable "public_subnet_prefixes" { type = list(string) }
variable "private_subnet_prefixes" { type = list(string) }

resource "azurerm_virtual_network" "this" {
  name                = var.vnet_name
  address_space       = var.address_space
  location            = var.location
  resource_group_name = var.rg_name
}

resource "azurerm_subnet" "public" {
  name                 = "public-subnet"
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = var.public_subnet_prefixes
}

resource "azurerm_subnet" "private" {
  name                 = "private-subnet"
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = var.private_subnet_prefixes
}

output "vnet_id" { value = azurerm_virtual_network.this.id }
output "public_subnet_id" { value = azurerm_subnet.public.id }
output "private_subnet_id" { value = azurerm_subnet.private.id }