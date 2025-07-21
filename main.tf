terraform {
  cloud {
    organization = "your-organization-name"
    workspaces {
      name = "terraform-aws-ec2"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

resource "aws_instance" "example" {
  ami           = var.ami_id
  instance_type = var.instance_type
  tags = {
    Name = var.instance_name
  }
}