variable "db_password" {
  description = "Administrator password for the Azure PostgreSQL database"
  type        = string
  sensitive   = true
}

variable "my_ip" {
  description = "Your personal public IP address with CIDR notation (e.g., 102.22.143.41/32) for Bastion SSH access"
  type        = string
}