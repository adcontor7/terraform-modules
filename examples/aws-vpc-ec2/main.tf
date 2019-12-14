provider "aws" {
  region = "us-east-1"
}

module "network" {
  #TODO USE GITHUB
  source = "./modules/aws-network"

  providers = {
    aws = aws
  }
}