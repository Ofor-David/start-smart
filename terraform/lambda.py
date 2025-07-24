# lambda/lambda.py

import json


def make_response(status_code, body_dict):
    # Wraps the response in proper API Gateway format with CORS header
    return {
        "statusCode": status_code,
        "body": json.dumps(body_dict),
        # udpdate later for security
        "headers": {
            "Content-Type": "application/json",
            "Access-Control-Allow-Origin": "*",  # <--- Allow CORS
            "Access-Control-Allow-Headers": "*",  # <--- Allow headers
            "Access-Control-Allow-Methods": "OPTIONS,POST",
        },
    }


def handler(event, context):
    print(
        "Received event:", json.dumps(event)
    )  # turns event dictionary into string For cloudwatch logs

    # add enrichment/validation here
    body = json.loads(event["body"])  # parses req payload to python dict

    make_response(200, {"message": "Event recerived", "data": body})
