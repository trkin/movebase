# cluster
resource "aws_ecs_cluster" "movebase-ecs-cluster" {
  name = "movebase-ecs-cluster"
}

resource "aws_launch_configuration" "movebase-launch-configuration" {
  name_prefix          = "movebase-launchconfig"
  image_id             = var.ECS_AMIS[var.AWS_REGION]
  instance_type        = var.ECS_INSTANCE_TYPE
  key_name             = aws_key_pair.movebase-key-pair.key_name
  iam_instance_profile = aws_iam_instance_profile.movebase-iam-instance-profile-ecs-ec2.id
  security_groups      = [aws_security_group.movebase-security-group-allow-22-and-3000.id]
  user_data            = "#!/bin/bash\necho 'ECS_CLUSTER=movebase-ecs-cluster' > /etc/ecs/ecs.config\nstart ecs"
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "movebase-autoscaling-group" {
  name                 = "movebase-autoscaling-group"
  vpc_zone_identifier  = [aws_subnet.movebase-subnet-public-1.id, aws_subnet.movebase-subnet-public-2.id]
  launch_configuration = aws_launch_configuration.movebase-launch-configuration.name
  min_size             = 1
  max_size             = 1
  tag {
    key                 = "Name"
    value               = "movebase-ecs-ec2-container"
    propagate_at_launch = true
  }
}

