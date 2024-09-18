terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 5.0" #version
    }
  }
}

provider "aws" {
  region = "eu-west-1"
#  profile = "terraform"
}

resource "aws_instance" "web-srv" {
  ami = "ami-03cc8375791cb8bcf"
  instance_type = "t2.micro"
  tags = {
    Name = "web-test-terraform-srv"
  }
}
