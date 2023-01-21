# variable "ami" {
# }
variable "cidr" {}

variable "availability_zone" {
  type = list(string)
}
variable "private_subnets" {
  type = list(string)
}
variable "public_subnets" {
  type = list(string)
}

variable "myprofile" {
  description = "MyProfile Information"
}

variable "aws_region" {
  default = "us-east-2"
}

variable "instance_type" {}