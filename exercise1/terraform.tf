terraform {
  required_version = "= 0.11.10"

  backend "s3" {
    bucket = "ecs-workshop-terraform-state-dev"
    key = "shreyas-cluster-dev.tfstate"
    dynamodb_table = "Terraform-Lock-Table"
    encrypt = true
    region = "us-east-1"
  }
}

provider "aws" {
  region = "us-east-1"
  version = "~> 1.46"
}