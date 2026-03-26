resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags = { Name = "devops-vpc" }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
}

resource "aws_subnet" "public" {
  count = 2
  vpc_id = aws_vpc.main.id
  cidr_block = element(var.public_subnets, count.index)
  availability_zone = element(["ap-south-1a","ap-south-1b"], count.index)
  map_public_ip_on_launch = true
}

resource "aws_subnet" "private" {
  count = 2
  vpc_id = aws_vpc.main.id
  cidr_block = element(var.private_subnets, count.index)
  availability_zone = element(["ap-south-1a","ap-south-1b"], count.index)
}