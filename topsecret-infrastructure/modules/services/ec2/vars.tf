variable "instance_ami" {
  description = "AMI for aws EC2 instance"
  default = "ami-0e472933a1395e172"
}
variable "instance_type" {
  description = "type for aws EC2 instance"
  default = "t2.micro"
}
variable "security_groups_for_ec2" {
  type = list(string)
}
variable "subnet_for_ec2" {
  
}
variable "key_pair_for_ec2" {

}
variable "environment_tag" {
  description = "Environment"
  type = string
  default = "Test"
}
variable "owner_tag" {
  description = "Owner name"
  type = string
  default = "tstanislawczyk"
}
variable "prefix" {
  type = string
}
variable "project_name" {
  description = "Project name"
  type        = string
}