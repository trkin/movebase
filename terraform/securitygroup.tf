# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group
resource "aws_security_group" "movebase-security-group-allow-22-and-3000" {
  vpc_id      = aws_vpc.movebase-vpc.id
  name        = "movebase-security-group-allow-22-and-3000"
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port       = 3000
    to_port         = 3000
    protocol        = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    # security_groups = [aws_security_group.movebase-security-group-allow-80.id]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "movebase-security-group-allow-22-and-3000"
  }
}

resource "aws_security_group" "movebase-security-group-allow-80" {
  vpc_id      = aws_vpc.movebase-vpc.id
  name        = "movebase-security-group-allow-80"
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "movebase-security-group-allow-80"
  }
}

resource "aws_security_group" "movebase-security-group-rds" {
  name   = "movebase-security-group-rds"
  vpc_id = aws_vpc.movebase-vpc.id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "movebase-security-group-rds"
  }
}

