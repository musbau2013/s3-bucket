data "aws_kms_key" "existing" {
  key_id = "5e748598-416b-4982-86c1-a5490ce3c14b"
}



module "app_bucket" {
  source = "./modules/s3"
  ### tst
  bucket_name          = "tweakideaz-intl-dev-x4y7zq"
  create_kms_key       = true
  use_existing_kms_key = false


  kms_key_id = data.aws_kms_key.existing.arn

  tags = {
    Environment = "prod"
    Project     = "my-app"
  }
  
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
  sse_algorithm           = "aws:kms"
}
