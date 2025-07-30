aws_access_key="Your aws access key"
aws_secret_key="Your aws secret key"
aws_region = "us-east-1"

bucket_name="A bucket name for firehose to output to"
api_gateway_name = "A name for your api gateway"
lambda_func_name = "A name for your lambda ingestion function"
athena_bucket_name = "A name for your Athena query results bucket"
enable_force_destroy = true
execution_frequency = "cron(* 5 * * ? *)" # daily at 5 AM UTC
firehose_name = "A name for your Kinesis Firehose delivery stream(e.g., event-stream)"
firehose_buffering_interval = 60 # Buffering interval in seconds
firehose_buffering_size = 64 # Buffering size in MB
