terraform {
  backend "s3" {
    bucket = "movebase-terraform-state"
    key = "tfstate"
    region = "eu-central-1"
  }
}
