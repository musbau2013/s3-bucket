terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.9.0"
    }
  }
}



# Optional KMS key
resource "aws_kms_key" "this" {
  count                   = var.create_kms_key && !var.use_existing_kms_key ? 1 : 0
  description             = var.kms_key_description
  deletion_window_in_days = var.kms_deletion_window_days
}

# S3 Bucket
resource "aws_s3_bucket" "this" {
  bucket = var.bucket_name
  tags   = var.tags
}

# Public access block (fully dynamic)
resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id

  block_public_acls       = var.block_public_acls
  block_public_policy     = var.block_public_policy
  ignore_public_acls      = var.ignore_public_acls
  restrict_public_buckets = var.restrict_public_buckets

  depends_on = [aws_s3_bucket.this]
}

# Server-side encryption configuration
resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms" #var.sse_algorithm
      kms_master_key_id = var.use_existing_kms_key ? var.kms_key_id : aws_kms_key.this[0].arn
    }
  }

  depends_on = [
    aws_s3_bucket.this,
    # aws_kms_key.this
  ]
}
