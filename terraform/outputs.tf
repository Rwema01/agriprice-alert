output "instance_public_ip" {
  description = "Public IP of the compute instance"
  value       = module.agriprice_infrastructure.app_ip
}

output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.agriprice_infrastructure.vpc_id
}