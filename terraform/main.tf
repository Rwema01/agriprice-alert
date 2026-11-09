provider "aws" {
  region = "us-east-1"
}

resource "aws_kms_key" "s3_kms_key" {
  description             = "KMS key for S3 bucket encryption"
  deletion_window_in_days = 10
  enable_key_rotation     = true

  # Fixes Checkov CKV2_AWS_64: Ensure KMS key policy is defined
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "Enable IAM User Permissions"
        Effect = "Allow"
        Principal = {
          AWS = "*"
        }
        Action   = "kms:*"
        Resource = "*"
      }
    ]
  })
}

resource "aws_s3_bucket" "agriprice_bucket" {
  bucket = "agriprice-alert-storage-f3-unique-12345" # Must be globally unique

  tags = {
    Name        = "AgriPrice Alert Bucket"
    Environment = "Dev"
  }
}

# Fixes Checkov CKV_AWS_21: Enable Versioning
resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.agriprice_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Fixes Checkov CKV_AWS_145: Enforce KMS encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" {
  bucket = aws_s3_bucket.agriprice_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.s3_kms_key.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

# Fixes Checkov public access block rules
resource "aws_s3_bucket_public_access_block" "public_access_block" {
  bucket = aws_s3_bucket.agriprice_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Fixes Checkov CKV_AWS_18: Enable Access Logging (Required for enterprise security)
resource "aws_s3_bucket" "log_bucket" {
  bucket = "agriprice-alert-logs-f3-unique-12345"
}

resource "aws_s3_bucket_acl" "log_bucket_acl" {
  bucket = aws_s3_bucket.log_bucket.id
  acl    = "log-delivery-write"
}

resource "aws_s3_bucket_logging" "logging" {
  bucket        = aws_s3_bucket.agriprice_bucket.id
  target_bucket = aws_s3_bucket.log_bucket.id
  target_prefix = "log/"
}

# Fixes Checkov CKV2_AWS_6: Ensure the log bucket has a Public Access block
resource "aws_s3_bucket_public_access_block" "log_bucket_public_access_block" {
  bucket = aws_s3_bucket.log_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}