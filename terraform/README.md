# Terraform Infrastructure

This directory provisions the AWS infrastructure for AgriPrice Alert.

## Architecture (Advanced Pattern)
The infrastructure is modularized. The core VPC, Subnet, Security Group, and EC2 instance are defined in `modules/vpc_compute/`. The root `main.tf` calls this module, passing variables from `variables.tf` and exposing outputs via `outputs.tf`.

## Usage
1. Navigate to `terraform/`
2. Run `terraform init` to download the AWS provider.
3. Run `terraform plan` to see the resources to be created.
4. Run `terraform apply` and type `yes` to provision the VPC and Compute instance.