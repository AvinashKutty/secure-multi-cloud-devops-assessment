variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "alb_sg" {
  description = "ALB Security Group ID"
  type        = string
}

variable "ami" {
  description = "AMI ID"
  type        = string
}