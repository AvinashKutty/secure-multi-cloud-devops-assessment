output "alb_sg" {
  value = aws_security_group.alb_sg.id
}

output "tg_arn" {
  value = aws_lb_target_group.tg.arn
}

output "alb_dns" {
  value = aws_lb.alb.dns_name
}