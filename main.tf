# data "aws_kms_key" "existing" {
#   key_id = "14c95555-8150-4d89-b6a2-a7ef7974a13f"
# }

module "app_bucket" {
  source = "./modules/s3"
  ### tst
  bucket_name          = "tweakideaz-intlweb"
  create_kms_key       = true
  use_existing_kms_key = false

  # kms_key_id = data.aws_kms_key.existing.arn

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
