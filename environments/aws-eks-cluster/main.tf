##https://www.terraform.io/docs/providers/aws/r/eks_cluster.html


locals {
  cluster_name = "terraform-eks-demo"
}

provider "aws" {
  region = "us-east-1"
}

module "network" {
  source = "../../modules/vpc-aws"
  prefix  = local.cluster_name

  network_cidr        = "10.0.0.0/16"
  network_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
  }

  num_private_subnets = 2
  num_public_subnets  = 1
  subnets_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
  }

  enable_nat_gateway  = false

  providers = {
    aws = aws
  }
}

##
resource "aws_iam_role" "iam_role" {
  name = local.cluster_name
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY

  tags = {
    project = "terraform-examples"
  }

}


module "k8s-cluster" {
  #source = "git@github.com:adcontor7/terraform-modules.git//modules/eks-aws?ref=v0.0.1"
  source = "../../modules/eks-aws"

  providers = {
    aws = aws
  }

  cluster_name  = local.cluster_name
  create_eks    = true

  iam_role_name = aws_iam_role.iam_role.name
  iam_role_arn  = aws_iam_role.iam_role.arn
  vpc_id        = module.network.vpc_id
  subnets       = concat(module.network.private_subnets_ids, module.network.public_subnets_ids)
}

