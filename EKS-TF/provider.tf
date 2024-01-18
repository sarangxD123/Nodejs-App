terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.31.0"
    }
  }
}


provider "aws" {

   region = "eu-north-1"
}

#install and configure aws cli so it can use access key and secret access key of the same and you dont have to provide it if its congfigured
#use command aws configure