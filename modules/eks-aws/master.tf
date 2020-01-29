#####
# EKS Master Cluster IAM Role
#####
resource "aws_iam_role" "iam_role" {
  name = "${var.cluster_name}-iam_role"
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

}


resource "aws_iam_role_policy_attachment" "terraform-AmazonEKSClusterPolicy" {
  count           = var.create_eks ? 1 : 0

  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.iam_role.name
}

resource "aws_iam_role_policy_attachment" "terraform-AmazonEKSServicePolicy" {
  count           = var.create_eks ? 1 : 0

  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.iam_role.name
}


#####
# EKS Master Cluster Security Group
#####
resource "aws_security_group" "terraform-eks-cluster" {
  count           = var.create_eks ? 1 : 0

  name        = "${var.cluster_name}-cluster"
  description = "Cluster communication with worker nodes"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.cluster_name
  }
}


#####
# EKS Master Cluster
#####
resource "aws_eks_cluster" "this" {
  count           = var.create_eks ? 1 : 0

  name            = var.cluster_name
  role_arn        = aws_iam_role.iam_role.arn

  vpc_config {
    security_group_ids = [aws_security_group.terraform-eks-cluster[0].id]
    subnet_ids         = var.subnets
  }

  depends_on = [
    aws_iam_role_policy_attachment.terraform-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.terraform-AmazonEKSServicePolicy
  ]
}