# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_policy
resource "aws_autoscaling_policy" "movebase-autoscaling-policy-cpu" {
  name                   = "movebase-autoscaling-policy-cpu"
  autoscaling_group_name = aws_autoscaling_group.movebase-autoscaling-group.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "1"
  cooldown               = "300"
  policy_type            = "SimpleScaling"
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm
resource "aws_cloudwatch_metric_alarm" "movebase-cloudwatch-metric-alarm-cpu" {
  alarm_name          = "movebase-cloudwatch-metric-alarm-cpu"
  alarm_description   = "movebase-cloudwatch-metric-alarm-cpu"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "30"

  dimensions = {
    "AutoScalingGroupName" = aws_autoscaling_group.movebase-autoscaling-group.name
  }

  actions_enabled = true
  alarm_actions   = [aws_autoscaling_policy.movebase-autoscaling-policy-cpu.arn]
}

# scale down alarm
resource "aws_autoscaling_policy" "movebase-autoscaling-policy-cpu-scaledown" {
  name                   = "movebase-autoscaling-policy-cpu-scaledown"
  autoscaling_group_name = aws_autoscaling_group.movebase-autoscaling-group.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "-1"
  cooldown               = "300"
  policy_type            = "SimpleScaling"
}

resource "aws_cloudwatch_metric_alarm" "movebase-cloudwatch-metric-alarm-cpu-scaledown" {
  alarm_name          = "movebase-cloudwatch-metric-alarm-cpu-scaledown"
  alarm_description   = "movebase-cloudwatch-metric-alarm-cpu-scaledown"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "5"

  dimensions = {
    "AutoScalingGroupName" = aws_autoscaling_group.movebase-autoscaling-group.name
  }

  actions_enabled = true
  alarm_actions   = [aws_autoscaling_policy.movebase-autoscaling-policy-cpu-scaledown.arn]
}

