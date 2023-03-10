myprofile  = "default"
aws_region = "us-east-2"
#ami= "ami-0470e33cd681b2476"
cidr              = "10.0.0.0/16"
availability_zone = ["us-east-2a", "us-east-2b", "us-east-2c"]
private_subnets   = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
public_subnets    = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
instance_type     = "t3.small"