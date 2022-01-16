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
  default = "mykey"
}

variable "PATH_TO_PUBLIC_KEY" {
  default = "mykey.pub"
}

variable "NOTIFICATION_EMAIL" {
  default = "duleorlovic@gmail.com"
}

variable "DB_PASSWORD" {
  description = "RDS posgres user password"
  sensitive   = true
}
