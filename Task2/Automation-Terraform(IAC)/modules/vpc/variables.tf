module "vpc" {
  source = "./modules/vpc"
  vpc_cidr = var.vpc_cidr
  public_subnets = var.public_subnets
  private_subnets = var.private_subnets
}

module "alb" {
  source = "./modules/alb"
  vpc_id = module.vpc.vpc_id
  public_subnets = module.vpc.public_subnet_ids
}

module "ec2" {
  source = "./modules/ec2"
  vpc_id = module.vpc.vpc_id
  alb_sg = module.alb.alb_sg
  ami = "ami-0f58b397bc5c1f2e8"
}

module "asg" {
  source = "./modules/asg"
  private_subnets = module.vpc.private_subnet_ids
  launch_template_id = module.ec2.lt_id
  target_group_arn = module.alb.tg_arn
}