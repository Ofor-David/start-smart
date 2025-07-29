# main lambda
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/../src/main/lambda.py"
  output_path = "${path.module}/../src/main/lambda.zip"
}

resource "aws_lambda_function" "startsmart_handler" {
  function_name = var.lambda_func_name
  handler       = "lambda.handler"
  runtime       = "python3.12"
  role          = aws_iam_role.lambda_exec_role.arn

  filename            = data.archive_file.lambda_zip.output_path
  source_code_hash    = data.archive_file.lambda_zip.output_base64sha256
  timeout             = 5

  environment {
    variables = {
      BUCKET_NAME = var.bucket_name
    }
  }
}

resource "aws_lambda_permission" "api_gateway_permission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.startsmart_handler.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.startsmart_api.execution_arn}/*/*"
}


# athena lambda function 
data "archive_file" "athena_lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/../src/athena/lambda.py"
  output_path = "${path.module}/../src/athena/lambda.zip"
}

resource "aws_lambda_function" "athena_trigger" {
  function_name = var.athena_lamdba_func_name
  handler       = "lambda.handler"
  runtime       = "python3.12"
  role          = aws_iam_role.athena_lambda_exec_role.arn

  filename            = data.archive_file.athena_lambda_zip.output_path
  source_code_hash    = data.archive_file.athena_lambda_zip.output_base64sha256
  timeout             = 5

  environment {
    variables = {
      ATHENA_OUTPUT_LOCATION = "s3://${var.athena_bucket_name}/results/"
    }
  }
}