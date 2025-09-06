# data "aws_kms_key" "existing" {
#   key_id = "3e54b4d6-a534-4ba3-a3eb-d75c855a176e"
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
