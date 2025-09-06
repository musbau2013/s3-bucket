output "bucket_arn" {
  value = aws_s3_bucket.this.arn
}

output "bucket_name" {
  value = aws_s3_bucket.this.bucket
}

output "kms_key_arn" {
    # count                   = var.create_kms_key && !var.use_existing_kms_key ? 1 : 0
  # value = var.use_existing_kms_key == false ? aws_kms_key.this[0].arn : null
  value =  aws_kms_key.this[0].arn

  description = "KMS key ARN used for bucket encryption"
}
