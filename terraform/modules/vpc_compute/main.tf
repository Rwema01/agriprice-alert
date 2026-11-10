variable "aws_region" { default = "us-east-1" }
variable "instance_type" { default = "t2.micro" }

provider "aws" { region = var.aws_region }

resource "aws_vpc" "main_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = { Name = "agriprice-vpc" }
}

resource "aws_subnet" "main_subnet" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  tags = { Name = "agriprice-subnet" }
}

resource "aws_internet_gateway" "gw" { vpc_id = aws_vpc.main_vpc.id }

resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.main_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.main_subnet.id
  route_table_id = aws_route_table.rt.id
}

resource "aws_security_group" "app_sg" {
  name        = "agriprice-sg"
  vpc_id      = aws_vpc.main_vpc.id
  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "app_server" {
  ami                    = "ami-0c7217cdde317cfec" # Ubuntu 22.04
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.main_subnet.id
  vpc_security_group_ids = [aws_security_group.app_sg.id]
  tags = { Name = "agriprice-server" }
}

output "instance_public_ip" { value = aws_instance.app_server.public_ip }
output "vpc_id" { value = aws_vpc.main_vpc.id }