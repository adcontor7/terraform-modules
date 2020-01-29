# adcontor7/terraform-modules/aws-network


A terraform module to create an AWS VPC
## Assumptions

* You have an AWS account

## Usage example

A full example leveraging other community modules is contained in the [examples/aws-vpc](https://github.com/adcontor7/terraform-modules/tree/master/examples/aws-vpc).

```hcl
provider "aws" {
  region = "us-east-1"
}

module "network" {
  source = "git@github.com:adcontor7/terraform-modules.git//modules/aws-network?ref=v0.0.1"
  prefix  = "terraform-example"
  
  
  network_cidr        = "10.0.0.0/16"
  public_subnet_cidr  = "10.0.1.0/24"
  private_subnet_cidr = "10.0.2.0/24"
  enable_nat_gateway  = false
  
  providers = {
    aws = aws
  }
}

```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->


<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->