provider "aws" {
 region = "us-west-2"
}
resource "aws_s3_bucket" "tsterraform02-s3" {
  bucket = "tsterraform02-s3"

  lifecycle {
    prevent_destroy = false
  }

  versioning {
    enabled = false
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}
resource "aws_dynamodb_table" "tsterraform02-dynamodb" {
  name         = "tsterraform02-dynamodb"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}