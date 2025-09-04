variable "bucket_name" {
  type        = string
  description = "Name of the S3 bucket"
}

variable "tags" {
  type        = map(string)
  description = "Tags for the S3 bucket"
  default     = {}
}

variable "create_kms_key" {
  type        = bool
  description = "Whether to create a new KMS key for the bucket"
  default     = true
}

variable "use_existing_kms_key" {
  type        = bool
  description = "Whether to use an existing KMS key instead of creating one"
  default     = false
}

variable "kms_key_id" {
  type        = string
  description = "ARN or ID of an existing KMS key"
  default     = ""
}

variable "kms_key_description" {
  type        = string
  description = "Description for the new KMS key"
  default     = "KMS key for S3 bucket"
}

variable "kms_deletion_window_days" {
  type        = number
  description = "KMS key deletion window in days"
  default     = 7
}

variable "block_public_acls" {
  type        = bool
  description = "Block public ACLs"
  default     = true
}

variable "block_public_policy" {
  type        = bool
  description = "Block public bucket policies"
  default     = true
}

variable "ignore_public_acls" {
  type        = bool
  description = "Ignore public ACLs"
  default     = true
}

variable "restrict_public_buckets" {
  type        = bool
  description = "Restrict public buckets"
  default     = true
}

variable "sse_algorithm" {
  type        = string
  description = "Server-side encryption algorithm"
  default     = "aws:kms"
}
