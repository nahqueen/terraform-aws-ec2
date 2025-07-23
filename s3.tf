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

resource "aws_s3_bucket" "example-bucket" {
  bucket = "your-unique-bucket-name-omba"
  
  tags = {
    Name        = "Example Bucket"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_acl" "example_bucket_acl" {
  bucket = aws_s3_bucket.example_bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "example_bucket_versioning" {
  bucket = aws_s3_bucket.example_bucket.id
  
  versioning_configuration {
    status = "Enabled"
  }
}