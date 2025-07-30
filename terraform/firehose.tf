resource "aws_kinesis_firehose_delivery_stream" "events_firehose" {
  name        = var.firehose_name
  destination = "extended_s3"
  depends_on  = [aws_s3_bucket.event_lake]

  extended_s3_configuration {
    role_arn            = aws_iam_role.firehose_role.arn
    bucket_arn          = aws_s3_bucket.event_lake.arn
    prefix              = "events/!{partitionKeyFromQuery:year}/!{partitionKeyFromQuery:month}/!{partitionKeyFromQuery:day}/"
    error_output_prefix = "errors/!{firehose:error-output-type}/"
    file_extension      = ".json"
    compression_format  = "UNCOMPRESSED"
    buffering_interval  = var.firehose_buffering_interval
    buffering_size      = var.firehose_buffering_size


    dynamic_partitioning_configuration {
      enabled = true
    }

    processing_configuration {
      enabled = true

      # Required MetadataExtraction processor
      processors {
        type = "MetadataExtraction"

        parameters {
          parameter_name  = "JsonParsingEngine"
          parameter_value = "JQ-1.6"
        }
        parameters {
          parameter_name  = "MetadataExtractionQuery"
          parameter_value = "{year: .year, month: .month, day: .day}"
        }
      }
    }

    # FIXME:Log group not being created
    cloudwatch_logging_options {
      enabled         = true
      log_group_name  = "/aws/kinesisfirehose/event-stream"
      log_stream_name = "S3Delivery"
    }
  }
}
