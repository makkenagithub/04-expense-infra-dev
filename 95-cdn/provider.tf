terraform {
    required_providers {
      aws = {
            source = "hashicorp/aws"
            version = "5.67.0"
        }
    }

    
    # backend block is to configure remote state
    backend "s3" {
        bucket = "s3 bucket name its unique across global 81s-remote-state"
        key = "expense-sg-cdn" # we have to give different key
        region = "us-east-1"
        dynamodb_table = "dynamo db table name- 81s-locking" 

    }
    
}

provider "aws" {
    # configuration oprtions
    region = "us-east-1"
}
