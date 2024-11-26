output "frontend_ecr" {
  description = "フロントエンド用のECRリポジトリ名"
  value       = aws_ecr_repository.frontend.name
}

output "backend_ecr" {
  description = "バックエンド用のECRリポジトリ名"
  value       = aws_ecr_repository.backend.name
}

output "ecr_push_role_arn" {
  description = "GitHub ActionsからECRにイメージをプッシュするためのIAMロールのARN"
  value       = aws_iam_role.ecr_push.arn
}
