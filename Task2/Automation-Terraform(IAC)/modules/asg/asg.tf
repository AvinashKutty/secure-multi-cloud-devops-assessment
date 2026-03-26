resource "aws_autoscaling_group" "asg" {
  desired_capacity = 2
  max_size         = 4
  min_size         = 2

  vpc_zone_identifier = var.private_subnets

  launch_template {
    id      = var.launch_template_id
    version = "$Latest"
  }

  target_group_arns = [var.target_group_arn]
}

resource "aws_autoscaling_policy" "cpu_policy" {
  autoscaling_group_name = aws_autoscaling_group.asg.name
  policy_type = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 60.0
  }
}