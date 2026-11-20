module "agriprice_infrastructure" {
  source        = "./modules/vpc_compute"
  aws_region    = var.aws_region
  instance_type = var.instance_type
  db_name       = var.db_name
  db_user       = var.db_user
  db_password   = var.db_password
  my_ip         = var.my_ip
}

output "bastion_ip" { value = module.agriprice_infrastructure.bastion_public_ip }
output "app_ip" { value = module.agriprice_infrastructure.app_private_ip }
output "ecr_url" { value = module.agriprice_infrastructure.ecr_url }
output "rds_endpoint" { value = module.agriprice_infrastructure.rds_endpoint }