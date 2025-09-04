module "app_bucket" {
  source = "./modules/s3"

  bucket_name          = "tweakideaz-intl-dev-x4y7zq"
  create_kms_key       = true
  use_existing_kms_key = false
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
