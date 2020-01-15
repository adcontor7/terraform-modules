#####
# EKS Master Cluster IAM Role
#####
resource "aws_iam_role" "iam_role" {
  name = "${var.cluster_name}-master"
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
