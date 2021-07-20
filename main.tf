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
  ami= "ami-0a8b4ae5c9d83fe6e"
  instance_type = "t2.micro"
  tags = {
      Name = "test-instance"
      Environment = "Dev"
  }
}