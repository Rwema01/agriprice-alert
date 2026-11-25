output "bastion_public_ip" {
  description = "Public IP address of the Bastion Host for SSH access"
  value       = azurerm_public_ip.bastion_ip.ip_address
}

output "app_private_ip" {
  description = "Private IP address of the Application VM"
  value       = azurerm_network_interface.app_nic.private_ip_address
}

output "acr_url" {
  description = "Login server URL for the Azure Container Registry"
  value       = azurerm_container_registry.acr.login_server
}

output "db_endpoint" {
  description = "FQDN of the Azure PostgreSQL Flexible Server"
  value       = azurerm_postgresql_flexible_server.db.fqdn
}