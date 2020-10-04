import json
import boto3
from boto3.dynamodb.conditions import Key


def lambda_handler(event, context):
    return delete_task(event)


def delete_task(event):
    client = boto3.resource("dynamodb")
    table = client.Table("Taskify")
    body = json.loads(event['body'])
    response = table.delete_item(Key={
        'id': body["id"],
        'username': body["username"]
    })
    return create_response(response)


def create_response(response):
    return {
        "statusCode": response['ResponseMetadata']['HTTPStatusCode'],
        "headers": {
            "Access-Control-Allow-Origin": "*",
            'Access-Control-Allow-Headers': 'Content-Type',
            'Access-Control-Allow-Methods': 'OPTIONS,DELETE'
        },
        "body": json.dumps({"message": "Task deleted successfully."}),
        "isBase64Encoded": False
    }
