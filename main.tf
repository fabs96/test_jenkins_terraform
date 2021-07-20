terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "us-east-2"
}

resource "aws_instance" "test-instance" {
  ami= "ami-0dc2d3e4c0f9ebd18"
  instance_type = "t3a.micro"
  tags = {
      Name = "test-instance"
      Environment = "Dev"
  }
}