variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "availability_zone" {
  type    = string
  default = ""
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "instance_name" {
  type    = string
  default = "spacelift-ec2"
}

variable "key_name" {
  type    = string
  default = ""
}

variable "ssh_ingress_cidr" {
  type    = string
  default = "0.0.0.0/0"
}
