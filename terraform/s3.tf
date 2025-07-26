resource "aws_s3_bucket" "event_lake" {
  bucket = "startsmart-event-lake"

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
