data "aws_iam_policy_document" "terraform_cloud_assume_role_policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]
    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.terraform_cloud.arn]
    }
    condition {
      test     = "StringEquals"
      variable = "${var.terraform_cloud_hostname}:aud"
      values   = [var.terraform_cloud_audience]
    }
    condition {
      test     = "StringLike"
      variable = "${var.terraform_cloud_hostname}:sub"
      values   = ["organization:Shah-Ammar-Terraform:project:Default Project:workspace:terraform-cli:run_phase:*"]
    }
  }
}

data "aws_iam_policy" "terraform_cloud_admin" {
  arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_role" "terraform_cloud_admin" {
  name               = "terraform-cloud-automation"
  assume_role_policy = data.aws_iam_policy_document.terraform_cloud_assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "terraform_cloud_admin" {
  role       = aws_iam_role.terraform_cloud_admin.name
  policy_arn = data.aws_iam_policy.terraform_cloud_admin.arn
}