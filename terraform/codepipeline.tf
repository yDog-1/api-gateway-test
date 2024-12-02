# resource "aws_codepipeline" "frontend_codepipeline" {
#   name          = "${local.kebab_project_name_prefix}-frontend-pipeline"
#   pipeline_type = "V2"
#   role_arn      = aws_iam_role.frontend_codepipeline_role.arn

#   artifact_store {
#     location = aws_s3_bucket.frontend_codepipeline_bucket.bucket
#     type     = "S3"
#   }

#   stage {
#     name = "Source"

#     action {
#       name             = "ECR_Source"
#       category         = "Source"
#       owner            = "AWS"
#       provider         = "ECR"
#       version          = "1"
#       output_artifacts = ["source_output"]

#       configuration = {
#         RepositoryName = aws_ecr_repository.frontend.name
#       }
#     }
#   }

#   stage {
#     name = "Build"

#     action {
#       name            = "Deploy_to_Lambda"
#       category        = "Build"
#       owner           = "AWS"
#       provider        = "CodeBuild"
#       version         = "1"
#       input_artifacts = ["source_output"]

#       configuration = {
#         ProjectName = aws_codebuild_project.frontend_lambda_deploy.name
#       }
#     }
#   }
# }

# resource "aws_iam_role" "frontend_codepipeline_role" {
#   name = "${local.kebab_project_name_prefix}-frontend-codepipeline-role"
#   path = "/${local.kebab_project_name_prefix}/codepipeline/"

#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = "sts:AssumeRole"
#         Effect = "Allow"
#         Principal = {
#           Service = "codepipeline.amazonaws.com"
#         }
#       }
#     ]
#   })
# }

# resource "aws_iam_role_policy" "frontend_codepipeline_policy" {
#   name   = "${local.kebab_project_name_prefix}-frontend-pipeline-policy"
#   role   = aws_iam_role.frontend_codepipeline_role.id
#   policy = data.aws_iam_policy_document.frontend_codepipeline_policy.json
# }

# data "aws_iam_policy_document" "frontend_codepipeline_policy" {
#   statement {
#     effect = "Allow"
#     actions = [
#       "s3:AssociateAccessGrantsIdentityCenter",
#       "s3:CreateAccessGrant",
#       "s3:CreateAccessGrantsInstance",
#       "s3:CreateAccessGrantsLocation",
#       "s3:CreateAccessPoint",
#       "s3:CreateAccessPointForObjectLambda",
#       "s3:CreateBucket",
#       "s3:CreateJob",
#       "s3:CreateMultiRegionAccessPoint",
#       "s3:DeleteAccessGrant",
#       "s3:PutObject"
#     ]
#     resources = [
#       aws_s3_bucket.frontend_codepipeline_bucket.arn,
#       "${aws_s3_bucket.frontend_codepipeline_bucket.arn}/*"
#     ]
#   }

#   statement {
#     effect = "Allow"
#     actions = [
#       "logs:CreateLogGroup",
#       "logs:CreateLogStream"
#     ]
#     resources = ["*"]
#   }

#   statement {
#     effect = "Allow"
#     actions = [
#       "codebuild:BatchGetBuilds",
#       "codebuild:StartBuild"
#     ]
#     resources = [aws_codebuild_project.frontend_lambda_deploy.arn]
#   }

#   statement {
#     effect = "Allow"
#     actions = [
#       "ecr:DescribeImages"
#     ]
#     resources = [aws_ecr_repository.frontend.arn]
#   }
# }
