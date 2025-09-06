output "bucket_arn" {
  value = aws_s3_bucket.this.arn
}

output "bucket_name" {
  value = aws_s3_bucket.this.bucket
}

output "kms_key_arn" {
  value       = aws_kms_key.this.arn
  description = "KMS key ARN used for bucket encryption"
}
