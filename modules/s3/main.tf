### Create Resources
resource "aws_s3_bucket" "app" {
  bucket = var.bucket

  tags   = var.tags
}

# S3 Private ACL
resource "aws_s3_bucket_acl" "bucket_acl" {
  bucket = aws_s3_bucket.app.id
  acl    = "private"
}

### Define Output
output "s3_bucket_name" {
  description = "The name of the bucket"
  value       = aws_s3_bucket.app.id
}

output "s3_bucket_name_arn" {
  description = "The name of the bucket"
  value       = aws_s3_bucket.app.arn
}