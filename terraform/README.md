# Terraform Infrastructure

This directory provisions the Azure infrastructure for AgriPrice Alert.

## Architecture
The infrastructure is modularized. The core VNet, Subnets, NSG, Bastion VM, App VM, ACR, and Azure PostgreSQL Database are defined in `main.tf`. Variables are passed via `variables.tf` and infrastructure details are exposed via `outputs.tf`.

## Usage
1. Navigate to `terraform/`
2. Run `terraform init` to download the Azure provider.
3. Run `terraform plan` to see the resources to be created.
4. Run `terraform apply` and type `yes` to provision the infrastructure.