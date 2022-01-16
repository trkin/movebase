# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic
resource "aws_sns_topic" "movebase-sns-topic" {
  name         = "movebase-sns-topic"
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_subscription
resource "aws_sns_topic_subscription" "user_updates_sqs_target" {
  topic_arn = aws_sns_topic.movebase-sns-topic.arn
  protocol = "email"
  endpoint = var.NOTIFICATION_EMAIL
}

resource "aws_autoscaling_notification" "example-notify" {
  group_names = [aws_autoscaling_group.movebase-autoscaling-group.name]
  topic_arn     = aws_sns_topic.movebase-sns-topic.arn
  notifications  = [
    "autoscaling:EC2_INSTANCE_LAUNCH",
    "autoscaling:EC2_INSTANCE_TERMINATE",
    "autoscaling:EC2_INSTANCE_LAUNCH_ERROR"
  ]
}
