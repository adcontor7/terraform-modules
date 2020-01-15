


#####
# EKS Worker Node Security Group
#####
resource "aws_security_group" "terraform-eks-node" {
  count           = var.create_eks ? 1 : 0

  name        = "${var.cluster_name}-node"
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
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  }
}

resource "aws_security_group_rule" "eks-node-ingress-self" {
  description              = "Allow node to communicate with each other"
  from_port                = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.terraform-eks-node.id
  source_security_group_id = aws_security_group.terraform-eks-node.id
  to_port                  = 65535
  type                     = "ingress"
}

resource "aws_security_group_rule" "eks-node-ingress-cluster" {
  description              = "Allow worker Kubelets and pods to receive communication from the cluster control      plane"
  from_port                = 1025
  protocol                 = "tcp"
  security_group_id        = aws_security_group.terraform-eks-node.id
  source_security_group_id = aws_security_group.terraform-eks-cluster.id
  to_port                  = 65535
  type                     = "ingress"
 }


#####
# Worker Node Access to EKS Master Cluster
#####

resource "aws_security_group_rule" "demo-cluster-ingress-node-https" {
  description              = "Allow pods to communicate with the cluster API Server"
  from_port                = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.terraform-eks-cluster.id
  source_security_group_id = aws_security_group.terraform-eks-node.id
  to_port                  = 443
  type                     = "ingress"
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