resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "${var.prefix}-${terraform.workspace}-db_subnet_group"
  subnet_ids = var.subnets_ids_list

tags = {
    Environment = var.environment_tag
    Name = "${var.prefix}-${terraform.workspace}-db_subnet_group"
    }
}
resource "aws_db_instance" "db_instance" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  name                 = "mydb01"
  username             = "foo"
  password             = "foobarbaz"
  parameter_group_name = "default.mysql5.7"
  db_subnet_group_name = aws_db_subnet_group.db_subnet_group.id
  skip_final_snapshot = true
  vpc_security_group_ids = var.security_groups_ids_list
  multi_az = true
  tags = {
    Environment = var.environment_tag
    Name = "${var.prefix}-${terraform.workspace}-db"
    }
}