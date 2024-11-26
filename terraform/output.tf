output "frontend_ecr" {
  description = "フロントエンド用のECRリポジトリURL"
  value       = aws_ecr_repository.frontend.repository_url
  sensitive   = true
}

output "backend_ecr" {
}

output "ecr_push_role_arn" {
  description = "GitHub ActionsからECRにイメージをプッシュするためのIAMロールのARN"
  value       = aws_iam_role.ecr_push.arn
}
