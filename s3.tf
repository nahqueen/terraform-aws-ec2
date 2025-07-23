terraform {
  cloud {
    organization = "Bright-Mind-Tech-TFC_Demo-1"
    workspaces {
      name = "terraform-aws-ec2-2"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

resource "aws_s3_bucket" "example_bucket" {
  bucket = "your-unique-bucket-name-omba1"
  
  tags = {
    Name        = "Example Bucket"
    Environment = "Dev"
  }
}

# First, configure Object Ownership to enable ACLs
resource "aws_s3_bucket_ownership_controls" "example_bucket_ownership" {
  bucket = aws_s3_bucket.example_bucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

# Next, disable Block Public Access settings to allow ACLs
resource "aws_s3_bucket_public_access_block" "example_bucket_public_access" {
  bucket = aws_s3_bucket.example_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# Finally, set the ACL (with explicit dependencies)
resource "aws_s3_bucket_acl" "example_bucket_acl" {
  depends_on = [
    aws_s3_bucket_ownership_controls.example_bucket_ownership,
    aws_s3_bucket_public_access_block.example_bucket_public_access
  ]
  
  bucket = aws_s3_bucket.example_bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "example_bucket_versioning" {
  bucket = aws_s3_bucket.example_bucket.id
  
  versioning_configuration {
    status = "Enabled"
  }
}