# doesnt run anything, just sets up the eventbridge rule to trigger the lambda function
resource "aws_cloudwatch_event_rule" "daily_athena_query" {
  name                = "daily-athena-query"
  description         = "Triggers Athena query Lambda every day at 5 AM UTC"
  schedule_expression = "cron(0 5 * * ? *)"  # 5:00 AM UTC daily
}

# Lambda function to be triggered by the event rule
resource "aws_cloudwatch_event_target" "invoke_lambda" {
  rule      = aws_cloudwatch_event_rule.daily_athena_query.name
  target_id = "trigger-athena-lambda"
  arn       = aws_lambda_function.athena_trigger.arn
}

