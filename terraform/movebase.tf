# connect to instance with ssh
# ssh -i ~/config/keys/movebase ec2-user@$(aws ec2 describe-instances --query "Reservations[*].Instances[*].PublicIpAddress" --output=text)
# tail /var/log/ecs/ecs-agent.log -f
# watch docker ps

# to redeploy first build and push image with tag your ecr repository and git sha
# export GIT_SHA=`git rev-parse HEAD`
# `aws ecr get-login --region eu-central-1 --no-include-email`
# docker build -t 219232999684.dkr.ecr.eu-central-1.amazonaws.com/movebase-ecr-repository:$GIT_SHA .
# docker push 219232999684.dkr.ecr.eu-central-1.amazonaws.com/movebase-ecr-repository:$GIT_SHA
#
# redeploying is targeting only ecs_service (which includes task_definition)
# cd terraform && terraform apply -target aws_ecs_service.movebase-ecs-service -var MOVEBASE_SERVICE_ENABLE=1 -var MOVEBASE_VERSION=$GIT_SHA -auto-approve
resource "aws_ecr_repository" "movebase-ecr-repository" {
  name = "movebase-ecr-repository"
}

output "movebase-ecr-repository-URL" {
  value = aws_ecr_repository.movebase-ecr-repository.repository_url
}

data "template_file" "movebase-task-definition-template" {
  template = file("templates/app.json.tpl")
  vars = {
    REPOSITORY_URL = replace(aws_ecr_repository.movebase-ecr-repository.repository_url, "https://", "")
    APP_VERSION    = var.MOVEBASE_VERSION
  }
}

resource "aws_ecs_task_definition" "movebase-ecs-task-definition" {
  family                = "movebase"
  container_definitions = data.template_file.movebase-task-definition-template.rendered
}

resource "aws_elb" "movebase-elb" {
  name = "movebase-elb"

  listener {
    instance_port     = 3000
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 30
    target              = "HTTP:3000/"
    interval            = 60
  }

  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  subnets         = [aws_subnet.movebase-subnet-public-1.id, aws_subnet.movebase-subnet-public-2.id]
  security_groups = [aws_security_group.movebase-security-group-allow-80.id]

  tags = {
    Name = "movebase-elb"
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service
resource "aws_ecs_service" "movebase-ecs-service" {
  count           = var.MOVEBASE_SERVICE_ENABLE
  name            = "movebase-ecs-service"
  cluster         = aws_ecs_cluster.movebase-ecs-cluster.id
  task_definition = aws_ecs_task_definition.movebase-ecs-task-definition.arn
  desired_count   = 1
  iam_role        = aws_iam_role.movebase-iam-role-ecs.arn
  depends_on      = [aws_iam_policy_attachment.movebase-iam-policy-attachment-ecs]

  load_balancer {
    elb_name       = aws_elb.movebase-elb.name
    container_name = "movebase-container"
    container_port = 3000
  }
  lifecycle {
    ignore_changes = [task_definition]
  }
}


output "elb_url" {
  value = aws_elb.movebase-elb.dns_name
}
