provider "aws" {
  region = "us-east-2"
}

resource "aws-instance" "test-instance" {
  ami= "ami-02de934ca4f3289e0"
  instance_type = "t2.micro"
  tags = {
      Name = "test-instance"
      Environment = "Dev"
  }
}