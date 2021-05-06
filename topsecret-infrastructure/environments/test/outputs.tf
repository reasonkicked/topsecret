output "vpc_01_id" {
  value = module.network.vpc_01_id
}
output "subnet_01_id" {
  description = "Id of subnet_01"
  value       = module.network.subnet_01_id
}
output "subnet_02_id" {
  description = "Id of subnet_02"
  value       = module.network.subnet_02_id
}
output "subnet_03_id" {
  description = "Id of subnet_03"
  value       = module.network.subnet_03_id
}
output "subnet_04_id" {
  description = "Id of subnet_04"
  value       = module.network.subnet_04_id
}
output "subnet_05_id" {
  description = "Id of subnet_05"
  value       = module.network.subnet_05_id
}
output "subnet_06_id" {
  description = "Id of subnet_06"
  value       = module.network.subnet_06_id
}

output "security_group_01_id" {
  description = "Id of security_group_01"
  value       = module.network.security_group_01_id
}
output "security_group_02_id" {
  description = "Id of security_group_02"
  value       = module.network.security_group_02_id
}
output "security_group_03_id" {
  description = "Id of security_group_03"
  value       = module.network.security_group_03_id
}
output "security_group_04_id" {
  description = "Id of security_group_04"
  value       = module.network.security_group_04_id
}
/*
output "ec2_instance_id" {
  value = module.ec2_write_node_primary.ec2_instance_id
}

*/
output "s3_distribution_domain_name" {
  value = module.cdn_01.s3_distribution_domain_name
}