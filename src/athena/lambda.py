# script for the lambda to be run with eventBridge daily

import boto3
import datetime
import os
import time

ATHENA_DATABASE = 'event_lake_db'
ATHENA_TABLE = 'event_events'
ATHENA_OUTPUT = os.environ['ATHENA_OUTPUT_LOCATION']
CRAWLER_NAME = os.environ['CRAWLER_NAME']
glue = boto3.client('glue')

def wait_for_crawler(timeout=300, interval=10):
    """Wait for the Glue crawler to finish."""
    start_time = datetime.datetime.now()
    while True:
        response = glue.get_crawler(Name=CRAWLER_NAME)
        status = response['Crawler']['State']
        if status == 'READY':
            print(f"Crawler {CRAWLER_NAME} is ready.")
            return
        elif status == 'RUNNING':
            elapsed_time = (datetime.datetime.now() - start_time).total_seconds()
            if elapsed_time > timeout:
                raise TimeoutError(f"Crawler {CRAWLER_NAME} did not finish in time.")
        else:
            raise RuntimeError(f"Crawler {CRAWLER_NAME} failed with status: {status}")
        time.sleep(interval)  # Wait before checking again

def handler(event, context):
    today = datetime.datetime.now()
    year = today.strftime('%Y')
    month = today.strftime('%m')
    day = today.strftime('%d')

    # Modify to change query
    query = f"""
    SELECT title, COUNT(*) as total
    FROM {ATHENA_DATABASE}.{ATHENA_TABLE}
    WHERE year = '{year}' AND month = '{month}' AND day = '{day}'
    GROUP BY title
    """

    athena = boto3.client('athena')
    
    # wait for crawler
    wait_for_crawler()

    response = athena.start_query_execution(
        QueryString=query,
        QueryExecutionContext={'Database': ATHENA_DATABASE},
        ResultConfiguration={'OutputLocation': ATHENA_OUTPUT}
    )

    return {
        'statusCode': 200,
        'body': f"Query started: {response['QueryExecutionId']}"
    }
