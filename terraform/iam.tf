# ecs ec2 role
resource "aws_iam_role" "movebase-iam-role-ecs-ec2" {
  name               = "movebase-iam-role-ecs-ec2"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

}

resource "aws_iam_instance_profile" "movebase-iam-instance-profile-ecs-ec2" {
  name = "movebase-iam-instance-profile-ecs-ec2"
  role = aws_iam_role.movebase-iam-role-ecs-ec2.name
}

resource "aws_iam_role" "movebase-iam-role-ecs-consul" {
  name = "movebase-iam-role-ecs-consul"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

}

resource "aws_iam_role_policy" "movebase-iam-role-policy-ecs-ec2" {
name   = "movebase-iam-role-policy-ecs-ec2"
role   = aws_iam_role.movebase-iam-role-ecs-ec2.id
policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
              "ecs:CreateCluster",
              "ecs:DeregisterContainerInstance",
              "ecs:DiscoverPollEndpoint",
              "ecs:Poll",
              "ecs:RegisterContainerInstance",
              "ecs:StartTelemetrySession",
              "ecs:Submit*",
              "ecs:StartTask",
              "ecr:GetAuthorizationToken",
              "ecr:BatchCheckLayerAvailability",
              "ecr:GetDownloadUrlForLayer",
              "ecr:BatchGetImage",
              "logs:CreateLogStream",
              "logs:PutLogEvents"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents",
                "logs:DescribeLogStreams"
            ],
            "Resource": [
                "arn:aws:logs:*:*:*"
            ]
        }
    ]
}
EOF

}

# ecs service role
resource "aws_iam_role" "movebase-iam-role-ecs" {
name = "movebase-iam-role-ecs"
assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ecs.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

}

resource "aws_iam_policy_attachment" "movebase-iam-policy-attachment-ecs" {
  name       = "movebase-iam-policy-attachment-ecs"
  roles      = [aws_iam_role.movebase-iam-role-ecs.name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceRole"
}

