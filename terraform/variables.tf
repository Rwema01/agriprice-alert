variable "aws_region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "instance_type" {
  description = "EC2 instance type"
  default     = "t2.micro"
}

variable "db_name" {
  description = "Name of the database"
  default     = "agriprice"
}

variable "db_user" {
  description = "Database administrator username"
  default     = "postgres"
}

variable "db_password" {
  description = "Database administrator password"
  sensitive   = true
}

variable "my_ip" {
  description = "Your personal IP address for Bastion SSH access (e.g., 1.2.3.4/32)"
  type        = string
}
