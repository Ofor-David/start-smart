# iam role for main lambda function
resource "aws_iam_role" "lambda_exec_role" {
  name = "startsmart-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        },
        Action = "sts:AssumeRole",
      },
    ]
  })
}

resource "aws_iam_role_policy" "s3_put_policy" {
  name = "allow-s3-put-events"
  role = aws_iam_role.lambda_exec_role.name
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = "s3:PutObject",
        Resource = "${aws_s3_bucket.event_lake.arn}/events/*"

      }
    ]
  })

}

resource "aws_iam_policy_attachment" "lambda_basic_execution" {
  name       = "attach-lambda-logs"
  roles      = [aws_iam_role.lambda_exec_role.name, aws_iam_role.athena_lambda_exec_role.name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# IAM role for glue crawler
resource "aws_iam_role" "glue_crawler_role" {
  name = "glue-crawler-access"

  assume_role_policy = jsonencode(
    {
      Version = "2012-10-17",
      Statement = [{
        Effect = "Allow",
        Action = "sts:AssumeRole",
        Principal = {
          Service = "glue.amazonaws.com"
        }
      }]
    }
  )
}

# glue crawler policies for s3
resource "aws_iam_role_policy" "glue_crawler_policy" {
  name = "glue-crawler-s3-policy"
  role = aws_iam_role.glue_crawler_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow",
        Action = ["s3:GetObject", "s3:ListBucket"],
        Resource = [
          "${aws_s3_bucket.event_lake.arn}",
          "${aws_s3_bucket.event_lake.arn}/*"
        ]
      },
      {
        Effect   = "Allow",
        Action   = ["glue:*"],
        Resource = "*"
      }
    ]
  })

}

# Athena lambda exec role
resource "aws_iam_role" "athena_lambda_exec_role" {
  name = "startsmart-athena-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        },
        Action = "sts:AssumeRole",
      },
    ]
  })
}

resource "aws_iam_role_policy" "athena__policy" {
  name = "allow-athena-s3-put-events"
  role = aws_iam_role.athena_lambda_exec_role.name
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = ["s3:PutObject", "s3:GetBucketLocation"],
        Resource = "${aws_s3_bucket.athena_results_bucket.arn}/*",
      },
      {
        Effect = "Allow",
        Action = [
          "athena:StartQueryExecution",
          "athena:GetQueryExecution",
          "athena:GetQueryResults",
        ],
        Resource = "*"
      }
    ]
  })

}

# Allow eventbridge to invoke the Athena lambda function
resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = var.athena_lamdba_func_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.daily_athena_query.arn
}
