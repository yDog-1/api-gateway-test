resource "aws_s3_bucket" "frontend_codepipeline_bucket" {
  bucket = "${local.kebab_project_name_prefix}-frontend-codepipeline-bucket"
}
