# without value or default will be asked
variable "AWS_REGION" {
  default = "eu-central-1"
}

variable "AMIS" {
  type = map
  default = {
    # find ami on https://cloud-images.ubuntu.com/locator/ec2/ search example
    # us-east-1 hvm
    # https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/finding-an-ami.html#finding-quick-start-ami
    eu-central-1 = "ami-009fefb5b9dd6ce4f"
  }
}

variable "PATH_TO_PRIVATE_KEY" {
  default = "~/config/keys/movebase"
}

variable "PATH_TO_PUBLIC_KEY" {
  default = "~/config/keys/movebase.pub"
}

variable "NOTIFICATION_EMAIL" {
  default = "duleorlovic@gmail.com"
}

variable "DB_PASSWORD" {
  description = "RDS postgres user password"
  sensitive   = true
}

variable "ECS_INSTANCE_TYPE" {
  default = "t2.micro"
}

# Full List: http://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-optimized_AMI.html
variable "ECS_AMIS" {
  type = map(string)
  default = {
    us-east-1 = "ami-1924770e"
    us-west-2 = "ami-56ed4936"
    eu-west-1 = "ami-c8337dbb"
    eu-central-1 = "ami-0dc66d9ab40653776"
  }
}

# this is used to disable service untill we have first MOVEBASE_VERSION
variable "MOVEBASE_SERVICE_ENABLE" {
  default = "0"
}

variable "MOVEBASE_VERSION" {
  default = "0"
}
