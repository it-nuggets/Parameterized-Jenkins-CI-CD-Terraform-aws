terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.10.0"
    }
  }
  backend "s3" {
    bucket                  = "terraform-s3-state-in-nuggets"
    key                     = "Parameterized-Jenkins-CI-CD-Terraform-aws-it-nuggets"
    region                  = "eu-central-1"
    shared_credentials_file = "~/.aws/credentials"
  }
}


provider "aws" {
  # Configuration options
  region =  var.aws_region
}

data "aws_ami" "amazon_linux" {
    most_recent = true
    owners      = ["amazon"]

    filter {
      name = "name"
      values = ["amzn2-ami-hvm-*-x86_64-gp2"]
    }
}

resource "aws_instance" "example" {
    ami = data.aws_ami.amazon_linux.id
    instance_type = var.instance_type
    key_name = var.key_name

    tags = {
      Name = var.name
    }

    user_data = <<-EOF
                #!/bin/bash
                sudo yum -y update
                sudo yum -y install httpd
                sudo systemctl start httpd
                sudo systemctl enable httpd
                EOF
    
    lifecycle {
    create_before_destroy = true
    }
}