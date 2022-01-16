# key is generated with ssh-keygen -f mykey
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair
resource "aws_key_pair" "movebase-key-pair" {
  # existing keys can be imported with: terraform import aws_key_pair.deployer deployer-key
  # https://console.aws.amazon.com/ec2/v2/home?region=us-east-1#KeyPairs:
  # movebase-key-pair will be destroyed when we run terraform destroy
  # Find IP address from aws console or using output and test connection with
  # ssh -i mykey ubuntu@3.84.117.126
  key_name = "movebase-key-pair"
  public_key = file(var.PATH_TO_PUBLIC_KEY)
}
