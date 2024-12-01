# LambdaからAssume Roleするためのポリシー
data "aws_iam_policy_document" "lambda_assume_role" {
  version = "2012-10-17"
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

# Lambda実行ロール
resource "aws_iam_role" "frontend_lambda_execution_role" {
  name               = "${local.kebab_project_name_prefix}-frontend-lambda-execution"
  path               = "/${local.kebab_project_name_prefix}/lambda/"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
}

# ロールにポリシーをアタッチする
resource "aws_iam_role_policy_attachment" "frontend_lambda_execution_role_basic" {
  role       = aws_iam_role.frontend_lambda_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole" # CloudWatch Logsへの書き込み許可
}
