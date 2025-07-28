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
  type = string
  
}

variable "lambda_func_name" {
  description = "lambda function name"
  type = string
}

variable "athena_bucket_name" {
  description = "S3 Bucket name for Athena query results"
  type        = string
  default     = "startsmart-athena-results"
  
}