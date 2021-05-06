output "vpc_01_id" {
  value = aws_vpc.vpc_01.id
}
output "subnet_01_id" {
  description = "Id of subnet_01"
  value       = aws_subnet.subnet_01.id
}
output "subnet_02_id" {
  description = "Id of subnet_02"
  value       = aws_subnet.subnet_02.id
}
output "subnet_03_id" {
  description = "Id of subnet_03"
  value       = aws_subnet.subnet_03.id
}
output "subnet_04_id" {
  description = "Id of subnet_04"
  value       = aws_subnet.subnet_04.id
}
output "subnet_05_id" {
  description = "Id of subnet_05"
  value       = aws_subnet.subnet_05.id
}
output "subnet_06_id" {
  description = "Id of subnet_06"
  value       = aws_subnet.subnet_06.id
}

output "security_group_01_id" {
  description = "Id of security_group_01"
  value       = aws_security_group.security_group_01.id
}
output "security_group_02_id" {
  description = "Id of security_group_02"
  value       = aws_security_group.security_group_02.id
}
output "security_group_03_id" {
  description = "Id of security_group_03"
  value       = aws_security_group.security_group_03.id
}
output "security_group_04_id" {
  description = "Id of security_group_04"
  value       = aws_security_group.security_group_04.id
}