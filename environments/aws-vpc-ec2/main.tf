provider "aws" {
  region = "us-east-1"
}

module "network" {
  #source = "git@github.com:adcontor7/terraform-modules.git//modules/vpc-aws?ref=v0.0.1"
  source = "../../modules/vpc-aws"
  prefix  = "terraform-example"

  network_cidr        = "10.0.0.0/16"
  network_tags = {
    key1 = "value1"
  }

  num_public_subnets  = 1
  subnets_tags = {
    key1 = "value2"
  }

  enable_nat_gateway  = false

  providers = {
    aws = aws
  }
}


##TODO IAM

##TODO EC2