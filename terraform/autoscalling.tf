# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_configuration
resource "aws_launch_configuration" "movebase-launchconfig" {
  name_prefix     = "movebase-launchconfig"
  image_id        = var.AMIS[var.AWS_REGION]
  instance_type   = "t2.micro"
  key_name        = aws_key_pair.movebase-key-pair.key_name
  security_groups = [aws_security_group.movebase-allow-ssh-and-all-egress.id]
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group
resource "aws_autoscaling_group" "movebase-autoscaling-group" {
  name                      = "movebase-autoscaling-group"
  vpc_zone_identifier       = [aws_subnet.movebase-subnet-public-1.id, aws_subnet.movebase-subnet-public-2.id]
  launch_configuration      = aws_launch_configuration.movebase-launchconfig.name
  min_size                  = 1
  max_size                  = 2
  health_check_grace_period = 300
  health_check_type         = "EC2"
  force_delete              = true

  tag {
    key                 = "Name"
    value               = "movebase-ec2-instance"
    propagate_at_launch = true
  }
}

# we could also use inline load_balancers inside "aws_autoscaling_group"
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_attachment
resource "aws_autoscaling_attachment" "movebase-autoscaling-group-attachment" {
  autoscaling_group_name = aws_autoscaling_group.movebase-autoscaling-group.name
  alb_target_group_arn   = aws_lb_target_group.movebase-lb-target-group.arn
}
