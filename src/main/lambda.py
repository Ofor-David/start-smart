# lambda/lambda.py

from datetime import datetime, timezone
import json
import uuid
import boto3
import os

s3 = boto3.client("s3")
BUCKET_NAME = os.environ['BUCKET_NAME']
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
    enriched["receivedAt"] = datetime.now(timezone.utc).isoformat().replace("+00:00", "Z")  # Server time in UTC
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
    
    # save to s3
    
    # Parse the UTC timestamp from receivedAt to get date components
    received_at = datetime.fromisoformat(enriched_event["receivedAt"].replace("Z", ""))
    year = received_at.year
    month = f"{received_at.month:02d}"
    day = f"{received_at.day:02d}"
    
    try:
        object_key = f"events/year={year}/month={month}/day={day}/{enriched_event['eventId']}.json"
        
        s3.put_object(
            Bucket=BUCKET_NAME,
            Key=object_key,
            Body=json.dumps(enriched_event),
            ContentType="application/json",
        )
    except Exception as e:
        print("s3 upload failed:", str(e))
        return make_response(500, {"failed to save event to storage"})
    # Return success response
    return make_response(200, {
        "message": "Event received and enriched successfully",
        "data": enriched_event
    })
    
 