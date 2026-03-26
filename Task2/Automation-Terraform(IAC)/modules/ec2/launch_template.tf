resource "aws_security_group" "ec2_sg" {
  vpc_id = var.vpc_id

  ingress {
    from_port = 3000
    to_port   = 3000
    protocol  = "tcp"
    security_groups = [var.alb_sg]
  }

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_launch_template" "lt" {
  name_prefix   = "devops-template"
  image_id      = var.ami
  instance_type = "t2.micro"

  user_data = base64encode(file("${path.module}/../../userdata.sh"))

  network_interfaces {
    security_groups = [aws_security_group.ec2_sg.id]
  }
}