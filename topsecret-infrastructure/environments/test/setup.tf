terraform {
  backend "s3" {
    
    //backend created in ./global/backend with local .tfstate

    bucket         = "tsterraform02-s3"
    key            = "terraform_state/terraform.tfstate"
    region         = "us-west-2"

  
    dynamodb_table = "tsterraform02-dynamodb"
    encrypt        = true
  }
  
}
provider "aws" {
 region = var.region
}