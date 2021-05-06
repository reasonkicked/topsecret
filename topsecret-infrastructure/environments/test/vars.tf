
variable "region"{
  type = string
  default = "us-west-2"
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
variable "code_s3_name" {
  type = string
}
variable "media_s3_name" {
  type = string
}