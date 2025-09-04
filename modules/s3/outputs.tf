output "bucket_arn" {
  value = aws_s3_bucket.this.arn
}

output "bucket_name" {
  value = aws_s3_bucket.this.bucket
}

output "kms_key_arn" {
  value       = var.use_existing_kms_key ? var.kms_key_id : aws_kms_key.this[0].arn
  description = "KMS key ARN used for bucket encryption"
}
