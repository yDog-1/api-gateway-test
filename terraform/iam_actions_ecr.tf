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
      "ecr:CompleteLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:InitiateLayerUpload",
      "ecr:BatchCheckLayerAvailability",
      "ecr:PutImage",
      "ecr:BatchGetImage"
    ]
    resources = local.ecr_repositories
  }
  statement {
    effect = "Allow"
    actions = [
      "ecr:GetAuthorizationToken"
    ]
    resources = ["*"]
  }
}

# Lambdaに新しいイメージをデプロイするためのIAMポリシードキュメント
data "aws_iam_policy_document" "lambda_deploy_policy" {
  statement {
    effect = "Allow"
    actions = [
      "lambda:UpdateFunctionCode",
    ]
    resources = [
      aws_lambda_function.frontend.arn
    ]
  }
}

# GitHub ActionsからAWSを操作するためのIAMロール
resource "aws_iam_role" "gha_role" {
  name               = "${local.kebab_project_name_prefix}-gha"
  path               = "/${local.kebab_project_name_prefix}/github-actions/"
  assume_role_policy = data.aws_iam_policy_document.ecr_push_assume.json
}

# ECR
resource "aws_iam_policy" "ecr_push_policy" {
  name   = "${local.kebab_project_name_prefix}-ecr-push-policy"
  path   = "/${local.kebab_project_name_prefix}/"
  policy = data.aws_iam_policy_document.ecr_push_policy.json
}
resource "aws_iam_role_policy_attachment" "ecr_push" {
  role       = aws_iam_role.gha_role.name
  policy_arn = aws_iam_policy.ecr_push_policy.arn
}

# Lambda
resource "aws_iam_policy" "lambda_deploy_policy" {
  name   = "${local.kebab_project_name_prefix}-lambda-deploy-policy"
  path   = "/${local.kebab_project_name_prefix}/"
  policy = data.aws_iam_policy_document.lambda_deploy_policy.json
}
resource "aws_iam_role_policy_attachment" "lambda_deploy" {
  role       = aws_iam_role.gha_role.name
  policy_arn = aws_iam_policy.lambda_deploy_policy.arn
}
