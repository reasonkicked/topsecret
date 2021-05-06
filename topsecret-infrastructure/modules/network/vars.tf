variable "cidr_vpc" {
  description = "CIDR block for the VPC"
  default = "10.1.0.0/16"
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

variable "vpc_name" {
  default = "vpc"  
}
variable "prefix" {
  type = string
}
variable "project_name" {
  description = "Project name"
  type        = string
}