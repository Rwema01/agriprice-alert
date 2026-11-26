variable "db_password" {
  description = "Administrator password for the Azure PostgreSQL database"
  type        = string
  sensitive   = true
}

variable "my_ip" {
  description = "Your personal public IP address with CIDR notation (e.g., 102.22.143.41/32) for Bastion SSH access"
  type        = string
}

variable "vnet_name" {
  description = "Name of the Virtual Network"
  type        = string
  default     = "agriprice-vnet"
}

variable "address_space" {
  description = "Address space for the VNet"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "public_subnet_prefixes" {
  description = "Address prefixes for the public subnet"
  type        = list(string)
  default     = ["10.0.1.0/24"]
}

variable "private_subnet_prefixes" {
  description = "Address prefixes for the private subnet"
  type        = list(string)
  default     = ["10.0.2.0/24"]
}