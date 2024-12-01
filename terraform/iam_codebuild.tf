data "aws_iam_policy_document" "codebuild_assume_role_policy" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["codebuild.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "frontend_codebuild_role" {
  name               = "${local.kebab_project_name_prefix}-frontend-codebuild"
  path               = "/${local.kebab_project_name_prefix}/codebuild/"
  assume_role_policy = data.aws_iam_policy_document.codebuild_assume_role_policy.json
}

data "aws_iam_policy_document" "frontend_codebuild_policy" {
  statement {
    effect = "Allow"
    actions = [
      "lambda:UpdateFunctionCode",
    ]
    resources = [aws_lambda_function.frontend.arn]
  }
}

resource "aws_iam_policy" "frontend_codebuild_policy" {
  name        = "${local.kebab_project_name_prefix}-frotend-codebuild-policy"
  description = "Allows CodeBuild to update the Lambda function"
  policy      = data.aws_iam_policy_document.frontend_codebuild_policy.json
}

resource "aws_iam_role_policy_attachment" "frontend_codebuild_policy" {
  role       = aws_iam_role.frontend_codebuild_role.name
  policy_arn = aws_iam_policy.frontend_codebuild_policy.arn
}

data "aws_iam_policy_document" "frontend_codebuild_logs_policy" {
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "frontend_codebuild_logs_policy" {
  name        = "${local.kebab_project_name_prefix}-frotend-codebuild-logs-policy"
  description = "Allows CodeBuild to create logs"
  policy      = data.aws_iam_policy_document.frontend_codebuild_logs_policy.json
}

resource "aws_iam_role_policy_attachment" "frontend_codebuild_logs_policy" {
  role       = aws_iam_role.frontend_codebuild_role.name
  policy_arn = aws_iam_policy.frontend_codebuild_logs_policy.arn
}

data "aws_iam_policy_document" "frontend_codebuild_s3_policy" {
  statement {
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:PutObject"
    ]
    resources = [
      aws_s3_bucket.frontend_codepipeline_bucket.arn,
      "${aws_s3_bucket.frontend_codepipeline_bucket.arn}/*"
    ]
  }
}

resource "aws_iam_policy" "frontend_codebuild_s3_policy" {
  name        = "${local.kebab_project_name_prefix}-frontend-codebuild-s3-policy"
  description = "Allows CodeBuild to access S3 bucket"
  policy      = data.aws_iam_policy_document.frontend_codebuild_s3_policy.json
}

resource "aws_iam_role_policy_attachment" "frontend_codebuild_s3_policy_attachment" {
  role       = aws_iam_role.frontend_codebuild_role.name
  policy_arn = aws_iam_policy.frontend_codebuild_s3_policy.arn
}
