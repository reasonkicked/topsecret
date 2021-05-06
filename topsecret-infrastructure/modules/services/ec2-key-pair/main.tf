resource "aws_key_pair" "key_pair" {
  key_name = var.name_of_key
  public_key = file(var.public_key_path)
}
