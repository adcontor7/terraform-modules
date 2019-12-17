resource "aws_iam_role" "default" {
  name = "${var.prefix}-iam"

  assume_role_policy = var.iam_policy
}
