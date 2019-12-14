provider "aws" {
  region = "us-east-1"
}

module "network" {
  source = "github.com/adcontor7/terraform-modules/modules/aws-network"
  prefix  = "terraform-example"
  providers = {
    aws = aws
  }
}