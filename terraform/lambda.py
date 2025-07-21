# lambda/lambda.py

import json

def handler(event, context):
    print("Received event:", json.dumps(event))

    # add enrichment/validation here
    body = json.loads(event['body'])

    """ return {
        "statusCode": 200,
        "body": json.dumps({
            "message": "Event received",
            "data": body
        }),
        "headers": {
            "Content-Type": "application/json"
        }
    } """
    return {
    "statusCode": 200,
    "body": json.dumps({
        "message": "Event received",
        "data": body
    }),
    "headers": {
        "Content-Type": "application/json",
        "Access-Control-Allow-Origin": "*",   # <--- Allow CORS
        "Access-Control-Allow-Headers": "*",  # <--- Allow headers
        "Access-Control-Allow-Methods": "OPTIONS,POST"
    }
}

