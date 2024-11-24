output "frontend_ecr" {
  description = "フロントエンド用のECRリポジトリURL"
  value       = aws_ecr_repository.frontend.repository_url
  sensitive   = true
}

output "backend_ecr" {
  description = "バックエンド用のECRリポジトリURL"
  value       = aws_ecr_repository.backend.repository_url
  sensitive   = true
}
