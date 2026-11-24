variable "db_password" {
  description = "Database administrator password"
  sensitive   = true
}

variable "my_ip" {
  description = "Your personal IP address for Bastion SSH access (e.g., 1.2.3.4/32)"
  type        = string
}