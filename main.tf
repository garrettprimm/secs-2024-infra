
terraform {
  required_version = "1.5.7"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.44.0"
    }
  }
}

provider "aws" {
}

resource "aws_s3_bucket" "main" {
  bucket = "secs-2024-is-awesome"
}


resource "aws_s3_bucket_public_access_block" "main" {
  bucket                  = aws_s3_bucket.main.id
  block_public_policy     = true
  block_public_acls       = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "main" {
  bucket = aws_s3_bucket.main.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_logging" "main" {
  bucket = aws_s3_bucket.main.id

  target_bucket = "secs-2024-logging-bucket"
  target_prefix = aws_s3_bucket.main.id
}

resource "aws_s3_bucket_versioning" "main" {
  bucket = aws_s3_bucket.main.id
  versioning_configuration {
    status = "Enabled"
  }
}

# module "secured_bucket" {
#   source      = "git::https://github.com/garrettprimm/secs-2024-hardened-s3.git?ref=v0.1.0"
#   owner       = "garrett@secs-2024.com"
#   bucket_name = "more_cool_stuff"
# }
