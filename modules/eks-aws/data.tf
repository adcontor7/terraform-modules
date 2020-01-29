data "template_file" "kubeconfig" {
  count    = var.create_eks ? 1 : 0
  template = file("${path.module}/templates/kubeconfig.tpl")

  vars = {
    kubeconfig_name           = local.kubeconfig_name
    endpoint                  = aws_eks_cluster.this[0].endpoint
    cluster_auth_base64       = aws_eks_cluster.this[0].certificate_authority[0].data
    aws_authenticator_command = "aws-iam-authenticator"
    aws_authenticator_command_args = "        - ${join(
      "\n        - ",
      formatlist("\"%s\"", ["token", "-i", aws_eks_cluster.this[0].name]),
    )}"
  }
}