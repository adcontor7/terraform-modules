provider "aws" {
  region = "us-east-1"
}

module "network" {
  source = "git@github.com:adcontor7/terraform-modules.git//modules/aws-network?ref=v0.0.1"
  prefix  = "terraform-example"
  providers = {
    aws = aws
  }
}