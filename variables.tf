variable "aws_region" {
    description = "AWS region"
    default = "eu-central-1"
}

variable "instance_type" {

    description = "EC2 instance type"
    default = "t2.micro"
}

variable "key_name" {
    description = "Name of the existing EC2 key pair"
    default = "it-nuggets"
  
}

variable "name" {
    description = "Name of EC2 Instance"
}