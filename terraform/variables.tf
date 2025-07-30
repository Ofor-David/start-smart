variable "aws_access_key" {
  description = "AWS Access Key"
  type        = string
  sensitive   = true

}
variable "aws_secret_key" {
  description = "AWS Secret Key"
  type        = string
  sensitive   = true

}
variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"

}
variable "bucket_name" {
  description = "S3 Bucket name"
  type        = string

}
variable "api_gateway_name" {
  description = "api gateway name"
  type        = string

}
variable "lambda_func_name" {
  description = "lambda function name"
  type        = string
}
variable "athena_bucket_name" {
  description = "S3 Bucket name for Athena query results"
  type        = string
  default     = "startsmart-athena-results"

}
variable "athena_lamdba_func_name" {
  description = "athena trigger lambda function name"
  type        = string
  default     = "athena-trigger-function"
}
variable "enable_force_destroy" {
  description = "Enable force destroy for ALL S3 buckets"
  type        = bool
  default     = false
}
variable "execution_frequency" {
  description = "Execution frequency for the glue crawler and Athena query trigger. E.g., 'cron(0 5 * * ? *)' for daily at 5 AM UTC. This means that the glue crawler and Athena query will run daily at 5 AM UTC."
  type        = string
  default     = "cron(0 5 * * ? *)"  # Default to every 3 minutescron(0/3 * * * ? *) for testing purposes

}
variable "firehose_name" {
  description = "Name of the Kinesis Firehose delivery stream"
  type        = string
  default     = "event-stream"
  
}
variable "firehose_buffering_interval" {
  description = "Buffering interval for Kinesis Firehose in seconds. This is the time Firehose waits before delivering data to S3. If the buffering size is reached before this interval, Firehose will deliver the data sooner."
  type        = number
  default     = 60  # Default to 60 seconds
  
}
variable "firehose_buffering_size" {
  description = "Buffering size for Kinesis Firehose in MB. This is the amount of data Firehose buffers before delivering to S3. if the buffering interval is reached before this size, Firehose will deliver the data sooner."
  type        = number
  default     = 64  # Default to 64 MB
  
}
