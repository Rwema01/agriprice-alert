module "agriprice_infrastructure" {
  source        = "./modules/vpc_compute"
  aws_region    = var.aws_region
  instance_type = var.instance_type
}

output "app_ip" { value = module.agriprice_infrastructure.instance_public_ip }
output "vpc_id" { value = module.agriprice_infrastructure.vpc_id }