# lambda/lambda.py

from datetime import datetime
import json
import uuid

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

def validate_event_data(data):
    # validates required field in the incoming event
    required_fields = ["title", "description", "startTime", "endTime"]
    missing_fields = [field for field in required_fields if field not in data]
    
    if missing_fields:
        return False, f"Missing required field(s): {',' .join(missing_fields)}"
    
    # time format validation
    try:
        datetime.fromisoformat(data["startTime"])
        datetime.fromisoformat(data["endTime"])
    except ValueError:
        return False, "Invalid timestamp format. Use ISO 8601 (e.g., '2025-07-23T10:00:00')"
    return True, None

def enrich_event_data(data):
    "add server side metadata to the event"
    enriched = data.copy()
    enriched["eventId"] = str(uuid.uuid4())  # Unique ID
    enriched["receivedAt"] = datetime.utcnow().isoformat() + "Z"  # Server time in UTC
    enriched["source"] = "startsmart-web"  # Optional, helps later for logs
    return enriched

def handler(event, context):
    print(
        "Received event:", json.dumps(event)
    )  # turns event dictionary into string For cloudwatch logs
    
    try:
        body = json.loads(event['body'])  # parses req payload to python dict
    except Exception:
        return make_response(400, {"error": "Invalid JSON in request body"})

    is_valid, error_message = validate_event_data(body)
    if not is_valid:
        return make_response(400, {"error": error_message})

    enriched_event = enrich_event_data(body)

    # Return success response
    return make_response(200, {
        "message": "Event received and enriched successfully",
        "data": enriched_event
    })