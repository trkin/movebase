# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group
resource "aws_security_group" "movebase-allow-ssh-and-all-egress" {
  vpc_id      = aws_vpc.movebase-vpc.id
  # this is a securty group name that is usually shown along with id
  name        = "movebase-allow-ssh-and-all-egress"
  description = "security group that allows ssh and all egress traffic"
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # this is a tag that is usually shown on index page, case sensitive
  tags = {
    Name = "movebase-allow-ssh-and-all-egress"
  }
}

# I use this so I can ping any instances in my VPC
resource "aws_security_group" "allow-ping" {
  vpc_id      = aws_vpc.movebase-vpc.id
  name        = "allow-ping"
  description = "security group that allows ping to it"
  ingress {
    from_port   = 8
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "allow-ping"
  }
}

resource "aws_security_group" "movebase-allow-80" {
  vpc_id      = aws_vpc.movebase-vpc.id
  name        = "movebase-allow-80"
  description = "security group that allows 80 for load balancer"
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "movebase-allow-80"
  }
}
