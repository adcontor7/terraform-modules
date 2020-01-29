##https://www.terraform.io/docs/providers/aws/r/eks_cluster.html
#https://learn.hashicorp.com/terraform/aws/eks-intro

terraform {
  backend "remote" {
    hostname = "app.terraform.io"
    organization = "adcontor7"

    workspaces {
      name = "aws-eks-cluster"
    }
  }
}

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
    "project" = "terraform-examples"
  }

  num_private_subnets = 2
  num_public_subnets  = 1
  subnets_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "project" = "terraform-examples"
  }

  enable_nat_gateway  = false

  providers = {
    aws = aws
  }
}




module "k8s-cluster" {
  #source = "git@github.com:adcontor7/terraform-modules.git//modules/eks-aws?ref=v0.0.1"
  source = "../../modules/eks-aws"

  providers = {
    aws = aws
  }

  cluster_name  = local.cluster_name
  ##False to Remove EKS Security Group and Cluster
  create_eks    = true

  vpc_id        = module.network.vpc_id
  subnets       = concat(module.network.private_subnets_ids, module.network.public_subnets_ids)

  #tags = {
  #  "project" = "terraform-examples"
  #}
}

