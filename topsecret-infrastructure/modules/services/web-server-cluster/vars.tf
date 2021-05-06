variable "vpc_id" {
  
}
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

variable "key_pair_for_ec2" {

}
/*
variable "user_data_script" {
  type        = string
  description = "User data content"
}
*/
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
variable "asg_subnets_ids_list" {
  type = list(string)
}
variable "min_size" {

}
variable "max_size" {

}
/*
variable "target_group_arns" {
  type = list(string)
}*/
variable "health_check_grace_period" {
  default = 120
}

variable "load_balancer_name" {
  
}
variable "load_balancer_type" {
  
  default = "application"
}
variable "load_balancer_subnets" {
  type = list(string)
}
variable "load_balancer_security_groups" {
  type = list(string)
}

variable "listener_content_type" {
  default = "text/plain"
}
variable "listener_message_body" {
  default = "404: page not found"
}
variable "listener_status_code" {
  default = 404
}

variable "target_id" {
 
}