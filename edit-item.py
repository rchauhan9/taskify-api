import boto3
import json
from boto3.dynamodb.conditions import Key


def lambda_handler(event, context):
    return update_task(event)


def update_task(event):
    client = boto3.resource("dynamodb")
    table = client.Table("Taskify")
    body = json.loads(event['body'])
    response = table.update_item(
        Key={
            'id': body['id'],
            'username': body['username']
        },
        UpdateExpression="set title=:t, notes=:n, deadline=:d, completed=:c",
        ExpressionAttributeValues={
            ':t': body['title'],
            ':n': body['notes'],
            ':d': body['deadline'],
            ':c': body['completed']
        },
        ReturnValues="UPDATED_NEW"
    )
    return create_response(response, body)


def create_response(response, task):
    return {
        "statusCode": response['ResponseMetadata']["HTTPStatusCode"],
        "headers": {
            "Access-Control-Allow-Origin": "*",
            'Access-Control-Allow-Headers': 'Content-Type',
            'Access-Control-Allow-Methods': 'OPTIONS,PATCH'
        },
        "body": json.dumps(task),
        "isBase64Encoded": False
    }