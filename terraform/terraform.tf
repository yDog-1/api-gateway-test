terraform {
  backend "s3" {
    key                         = "api-gateway-test/terraform.tfstate"
    region                      = "auto"
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    skip_requesting_account_id  = true
    skip_s3_checksum            = true
    use_path_style              = true
    use_lockfile                = true # State Lockを有効化
  }
  required_version = "~> 1.10"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = local.aws_region
  default_tags {
    tags = {
      type = "learn"
    }
  }
}

locals {
  aws_region                = "ap-northeast-1"
  project_name_prefix       = "api_gw_test"
  kebab_project_name_prefix = replace(local.project_name_prefix, "_", "-")
}
