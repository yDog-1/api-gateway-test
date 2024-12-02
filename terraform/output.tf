output "frontend_ecr" {
  description = "フロントエンド用のECRリポジトリ名"
  value       = aws_ecr_repository.frontend.name
}

output "backend_ecr" {
  description = "バックエンド用のECRリポジトリ名"
  value       = aws_ecr_repository.backend.name
}

output "gha_role_arn" {
  description = "GitHub Actionsからデプロイするための権限を持つIAMロールのARN"
  value       = aws_iam_role.gha_role.arn
}

output "frontend_lambda_arn" {
  description = "フロントエンド用のLambda関数名"
  value       = aws_lambda_function.frontend.function_name
}
