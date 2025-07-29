# script for the lambda to be run with eventBridge daily

import boto3
import datetime
import os

ATHENA_DATABASE = 'event-lake-db'
ATHENA_TABLE = 'event_events'
ATHENA_OUTPUT = os.environ['ATHENA_OUTPUT_LOCATION']

def handler(event, context):
    today = datetime.datetime.now()
    year = today.strftime('%Y')
    month = today.strftime('%m')
    day = today.strftime('%d')

    # Modify to change query
    query = f"""
    SELECT event_type, COUNT(*) as total
    FROM "{ATHENA_DATABASE}"."{ATHENA_TABLE}"
    WHERE year = '{year}' AND month = '{month}' AND day = '{day}'
    GROUP BY event_type
    """

    athena = boto3.client('athena')

    response = athena.start_query_execution(
        QueryString=query,
        QueryExecutionContext={'Database': ATHENA_DATABASE},
        ResultConfiguration={'OutputLocation': ATHENA_OUTPUT}
    )

    return {
        'statusCode': 200,
        'body': f"Query started: {response['QueryExecutionId']}"
    }
