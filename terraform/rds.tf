# tutorial https://learn.hashicorp.com/tutorials/terraform/aws-rds?in=terraform/aws
# psql -h $(terraform output -raw rds_hostname) -p $(terraform output -raw rds_port) -U $(terraform output -raw rds_username) postgres
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance
resource "aws_db_instance" "movebase-db-instance" {
  identifier             = "movebase-db-instance"
  instance_class         = "db.t3.micro"
  allocated_storage      = 5
  engine                 = "postgres"
  engine_version         = "13.1"
  username               = "postgres"
  password               = var.DB_PASSWORD
  db_subnet_group_name   = aws_db_subnet_group.movebase-db-subnet-group.name
  vpc_security_group_ids = [aws_security_group.movebase-security-group-rds.id]
  parameter_group_name   = aws_db_parameter_group.movebase-db-parameter-group.name
  publicly_accessible    = true
  skip_final_snapshot    = true
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_subnet_group
resource "aws_db_subnet_group" "movebase-db-subnet-group" {
  name = "movebase-db-subnet-group"
  subnet_ids = [aws_subnet.movebase-subnet-public-1.id,aws_subnet.movebase-subnet-public-2.id]
  tags = {
    Name = "movebase-db-subnet-group"
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_parameter_group
resource "aws_db_parameter_group" "movebase-db-parameter-group" {
  name   = "movebase-db-parameter-group"
  family = "postgres13"

  parameter {
    name  = "log_connections"
    value = "1"
  }
}


output "rds_hostname" {
  description = "RDS instance hostname"
  value       = aws_db_instance.movebase-db-instance.address
  sensitive   = true
}

output "rds_port" {
  description = "RDS instance port"
  value       = aws_db_instance.movebase-db-instance.port
  sensitive   = true
}

output "rds_username" {
  description = "RDS instance root username"
  value       = aws_db_instance.movebase-db-instance.username
  sensitive   = true
}
