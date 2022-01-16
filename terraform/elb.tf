# https://docs.aws.amazon.com/elasticloadbalancing/latest/application/introduction.html#application-load-balancer-components
# Each target group routes requests to one or more registered targets, such as
# EC2 instances, using the protocol and port number that you specify in
# listener. You can register a target with multiple target groups. You can
# configure health checks on a per target group basis. Health checks are
# performed on all targets registered to a target group that is specified in a
# listener rule for your load balancer.
# old https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elb classic
# new https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb which can be application, network, gateway
# todo: tutorial https://medium.com/cognitoiq/terraform-and-aws-application-load-balancers-62a6f8592bcf
# todo: long tutorial https://hiveit.co.uk/techshop/terraform-aws-vpc-example/
resource "aws_lb" "movebase-lb" {
  name            = "movebase-lb"
  security_groups = [aws_security_group.movebase-allow-ssh-and-all-egress.id, aws_security_group.movebase-allow-80.id]
  subnets         = [aws_subnet.movebase-subnet-public-1.id, aws_subnet.movebase-subnet-public-2.id]
  tags = {
    Name = "movebase-lb"
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener
# https://docs.aws.amazon.com/elasticloadbalancing/latest/application/load-balancer-listeners.html
resource "aws_lb_listener" "movebase-lb-listener-80" {
  load_balancer_arn = aws_lb.movebase-lb.arn
  port              = "80"
  protocol          = "HTTP" # fpr ALB: HTTP or HTTPS for NLB: TCP, TLS, UDP and TCP_UDP

  default_action {
    type             = "forward" # forward, redirect, fixed-response, authenticate-cognito and authenticate-oidc
    target_group_arn = aws_lb_target_group.movebase-lb-target-group.arn
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group
resource "aws_lb_target_group" "movebase-lb-target-group" {
  name             = "movebase-lb-target-group"
  port             = 80
  protocol         = "HTTP"
  vpc_id           = aws_vpc.movebase-vpc.id
  tags = {
    Name = "movebase-lb-target-group"
  }
  # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group#health_check
  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 30
  }
}

# to connect to autoscaling, we define a link in autoscalling.tf
# "aws_lb_target_group_attachment" is used to connect with specific instance
