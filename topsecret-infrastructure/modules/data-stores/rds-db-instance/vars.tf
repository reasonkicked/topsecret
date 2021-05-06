variable "subnets_ids_list" {
  type = list(string)
}
variable "security_groups_ids_list" {
  type = list(string)
}
variable "prefix" {
  type = string
}
variable "environment_tag" {
  description = "Environment"
    type = string
  default = "Test"
}