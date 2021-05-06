data "aws_availability_zones" "available" {
  state = "available"
}
/*
data "template_file" "user_data" {
  template = file("${path.module}/user-data.sh")

  vars = {
    
  }
}
*/