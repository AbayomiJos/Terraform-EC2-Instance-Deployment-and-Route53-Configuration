terraform {
  backend "s3" {
    bucket         = "terraform-bucket-04-02-2023"
    key            = "global/s3/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-project-locks"
    encrypt        = true
  }
} 