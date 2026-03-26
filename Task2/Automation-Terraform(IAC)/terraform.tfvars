# VPC CIDR
vpc_cidr = "10.0.0.0/16"

# Public subnets
public_subnets = [
  "10.0.1.0/24",
  "10.0.2.0/24"
]

# Private subnets
private_subnets = [
  "10.0.3.0/24",
  "10.0.4.0/24"
]

# AMI for EC2 instances (Amazon Linux 2)
ami = "ami-0f58b397bc5c1f2e8"