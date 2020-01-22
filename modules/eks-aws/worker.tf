


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
  security_group_id        = aws_security_group.terraform-eks-node[0].id
  source_security_group_id = aws_security_group.terraform-eks-cluster[0].id
  to_port                  = 65535
  type                     = "ingress"
}

resource "aws_security_group_rule" "eks-node-ingress-cluster" {
  description              = "Allow worker Kubelets and pods to receive communication from the cluster control      plane"
  from_port                = 1025
  protocol                 = "tcp"
  security_group_id        = aws_security_group.terraform-eks-node[0].id
  source_security_group_id = aws_security_group.terraform-eks-cluster[0].id
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
  security_group_id        = aws_security_group.terraform-eks-cluster[0].id
  source_security_group_id = aws_security_group.terraform-eks-node[0].id
  to_port                  = 443
  type                     = "ingress"
}

### TODO Continue https://learn.hashicorp.com/terraform/aws/eks-intro
### https://docs.aws.amazon.com/eks/latest/userguide/create-kubeconfig.html