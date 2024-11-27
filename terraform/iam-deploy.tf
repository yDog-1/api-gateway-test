locals {
  github_oidc_provider_arn = "arn:aws:iam::${local.aws_account_id}:oidc-provider/token.actions.githubusercontent.com"
}

# GitHub ActionsからECRにイメージをプッシュするためのIAMポリシードキュメント
data "aws_iam_policy_document" "ecr_push_assume" {
  version = "2012-10-17"
  statement {
    # GitHub ActionsによるAssume Roleの許可
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]
    principals {
      # OIDCプロバイダーの指定
      type        = "Federated"
      identifiers = [local.github_oidc_provider_arn]
    }
    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }
    condition {
      # リポジトリとブランチの指定
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:${var.git_author}/${var.git_repo}:ref:refs/heads/main"]
    }
  }
}

# ECRへのプッシュを許可するIAMポリシードキュメント
data "aws_iam_policy_document" "ecr_push_policy" {
  version = "2012-10-17"
  statement {
    effect = "Allow"
    actions = [
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:PutImage",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
    ]
    resources = local.ecr_repositories
  }
}

# GitHub ActionsからECRにイメージをプッシュするためのIAMロール
resource "aws_iam_role" "ecr_push" {
  name               = "${local.project_name_prefix}_ecr_push_role"
  assume_role_policy = data.aws_iam_policy_document.ecr_push_assume.json
}
resource "aws_iam_policy" "ecr_push_policy" {
  name   = "${local.project_name_prefix}_ecr_push_policy"
  policy = data.aws_iam_policy_document.ecr_push_policy.json
}
resource "aws_iam_role_policy_attachment" "ecr_push" {
  role       = aws_iam_role.ecr_push.name
  policy_arn = aws_iam_policy.ecr_push_policy.arn
}
