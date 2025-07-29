resource "aws_s3_bucket" "event_lake" {
  bucket = var.bucket_name
  force_destroy = var.enable_force_destroy

  tags = {
    Name        = "StartSmart Event Lake"
    Environment = "dev"
  }
}

resource "aws_s3_bucket_public_access_block" "event_lake_block" {
  bucket = aws_s3_bucket.event_lake.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "event_lake_versioning" {
  bucket = aws_s3_bucket.event_lake.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Athena query result bucket 
resource "aws_s3_bucket" "athena_results_bucket" {
  bucket = var.athena_bucket_name
  force_destroy = var.enable_force_destroy

}

resource "aws_s3_object" "results" {
  bucket = aws_s3_bucket.athena_results_bucket.id
  key    = "results/"
  content = "This bucket is used for Athena query results."

  tags = {
    Name        = "StartSmart Athena Results"
    Environment = "dev"
  }
  
}

resource "aws_s3_bucket_public_access_block" "athena_results_block" {
  bucket = aws_s3_bucket.athena_results_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "athena_results_bucket_versioning" {
  bucket = aws_s3_bucket.athena_results_bucket.id

  versioning_configuration {
    status = "Disabled" # Athena does not require versioning
  }
}
