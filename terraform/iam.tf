resource "aws_iam_role" "lambda_exec_role" {
  name = "startsmart-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      },
      Action = "sts:AssumeRole",
    }]
  })
}

resource "aws_iam_policy_attachment" "lambda_basic_execution" {
  name       = "attach-lambda-logs"
  roles      = [aws_iam_role.lambda_exec_role.name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
