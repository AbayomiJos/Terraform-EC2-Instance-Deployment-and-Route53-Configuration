# Set up remote storage of state files

## CREATE S3 BUCKET
# create bucket to store state files
resource "aws_s3_bucket" "terraform_state" {
  bucket = "terraform-bucket-04-02-2023"

  # prevent accidental deletion of this s3 bucket
  lifecycle {
    prevent_destroy = true
  }
}

# enable bucket versoning to save different versions of the state file so you can easily fall back to it
resource "aws_s3_bucket_versioning" "enabled" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

# enable server side encryption so content i.e state file stored in the bucket is encrpted
resource "aws_s3_bucket_server_side_encryption_configuration" "default" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

## disable public access to s3 bucket, as it may contain secrets that you cant afford to be leaked
resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket                  = aws_s3_bucket.terraform_state.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# DynamoDB is used for locking with teraform, you do that by creating a dynamodb table
# that has a primary key called LockID

resource "aws_dynamodb_table" "terraform_locks" {
  name         = "terraform-project-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}