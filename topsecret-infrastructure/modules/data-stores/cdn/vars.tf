variable "environment_tag" {
  description = "Environment"
    type = string
  default = "Test"
}
variable "prefix" {
  type = string
}
variable "code_s3_name" {
  type = string
}
variable "media_s3_name" {
  type = string
}