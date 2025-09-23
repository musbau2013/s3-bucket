data "aws_kms_key" "existing" {
  key_id = "b434f417-f3ac-4fbe-822a-5acece79412e"
}

module "app_bucket" {
  source = "./modules/s3"
  ### tst
  bucket_name          = "tweakideaz-intlweb"
  create_kms_key       = false
  use_existing_kms_key = true

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


module "static_website_bucket" {
  source = "./modules/s3"
  ### tst adsfddvdvddfsgfsgfsgsgdgfdgfg
  bucket_name          = "static-website-intlweb"
  create_kms_key       = false
  use_existing_kms_key = true

  kms_key_id = data.aws_kms_key.existing.arn

  tags = {
    Environment = "prod"
    Project     = "my-app"
  }
  
  block_public_acls       = false
  # block_public_policy     = false
  # ignore_public_acls      = true
  # restrict_public_buckets = true
  sse_algorithm           = "aws:kms"
}
