provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "statesfilebucket"
    key = "tweak-s3.statefile"
  }
}