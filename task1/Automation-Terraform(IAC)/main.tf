# ---------------- VPC ----------------
resource "aws_vpc" "vpn_vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "vpn-vpc"
  }
}

# ---------------- Subnets ----------------
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.vpn_vpc.id
  cidr_block              = var.public_subnet_cidr
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.vpn_vpc.id
  cidr_block = var.private_subnet_cidr

  tags = {
    Name = "private-subnet"
  }
}

# ---------------- Internet Gateway ----------------
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpn_vpc.id
}

# ---------------- Route Table (Public) ----------------
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpn_vpc.id
}

resource "aws_route" "public_internet" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

# ---------------- Security Group (VPN) ----------------
resource "aws_security_group" "vpn_sg" {
  name   = "vpn-sg"
  vpc_id = aws_vpc.vpn_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }

  ingress {
    from_port   = 1194
    to_port     = 1194
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ---------------- Security Group (Private EC2) ----------------
resource "aws_security_group" "private_sg" {
  name   = "private-sg"
  vpc_id = aws_vpc.vpn_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.8.0.0/24"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ---------------- VPN EC2 ----------------
resource "aws_instance" "vpn_server" {
  ami           = "ami-0f5ee92e2d63afc18" # Ubuntu (update if needed)
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_subnet.id
  key_name      = var.key_name

  vpc_security_group_ids = [aws_security_group.vpn_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              apt update -y
              apt install curl -y
              curl -O https://raw.githubusercontent.com/angristan/openvpn-install/master/openvpn-install.sh
              chmod +x openvpn-install.sh
              AUTO_INSTALL=y ./openvpn-install.sh
              EOF

  tags = {
    Name = "vpn-server"
  }
}

# ---------------- Private EC2 ----------------
resource "aws_instance" "private_ec2" {
  ami           = "ami-0f5ee92e2d63afc18"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.private_subnet.id
  key_name      = var.key_name

  vpc_security_group_ids = [aws_security_group.private_sg.id]

  tags = {
    Name = "internal-app"
  }
}