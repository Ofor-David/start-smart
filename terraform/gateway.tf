resource "aws_api_gateway_rest_api" "startsmart_api" {
  name        = "StartSmartAPI"
  description = "REST API for event ingestion"
}
resource "aws_api_gateway_resource" "track" {
  rest_api_id = aws_api_gateway_rest_api.startsmart_api.id
  parent_id   = aws_api_gateway_rest_api.startsmart_api.root_resource_id
  path_part   = "track"
}
resource "aws_api_gateway_method" "post_event" {
  rest_api_id   = aws_api_gateway_rest_api.startsmart_api.id
  resource_id   = aws_api_gateway_resource.track.id
  http_method   = "POST"
  authorization = "NONE"
}
resource "aws_api_gateway_integration" "lambda_integration" {
  rest_api_id             = aws_api_gateway_rest_api.startsmart_api.id
  resource_id             = aws_api_gateway_resource.track.id
  http_method             = "POST"
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.startsmart_handler.invoke_arn
}

resource "aws_api_gateway_deployment" "deployment" {
  depends_on  = [aws_api_gateway_integration.lambda_integration,
  aws_api_gateway_integration.options_integration]
  rest_api_id = aws_api_gateway_rest_api.startsmart_api.id

}

resource "aws_api_gateway_stage" "stage" {
  deployment_id = aws_api_gateway_deployment.deployment.id
  rest_api_id   = aws_api_gateway_rest_api.startsmart_api.id
  stage_name    = "dev"
}

# ----

resource "aws_api_gateway_method" "options_track" {
  rest_api_id   = aws_api_gateway_rest_api.startsmart_api.id
  resource_id   = aws_api_gateway_resource.track.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "options_integration" {
  rest_api_id             = aws_api_gateway_rest_api.startsmart_api.id
  resource_id             = aws_api_gateway_resource.track.id
  http_method             = aws_api_gateway_method.options_track.http_method
  type                    = "MOCK"
  integration_http_method = "OPTIONS"
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
}

resource "aws_api_gateway_method_response" "options_response" {
  rest_api_id = aws_api_gateway_rest_api.startsmart_api.id
  resource_id = aws_api_gateway_resource.track.id
  http_method = aws_api_gateway_method.options_track.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
}

resource "aws_api_gateway_integration_response" "options_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.startsmart_api.id
  resource_id = aws_api_gateway_resource.track.id
  http_method = aws_api_gateway_method.options_track.http_method
  status_code = aws_api_gateway_method_response.options_response.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
    "method.response.header.Access-Control-Allow-Methods" = "'OPTIONS,POST'"
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }

  response_templates = {
    "application/json" = ""
  }
}
