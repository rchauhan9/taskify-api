import json
import boto3
from boto3.dynamodb.conditions import Key

def lambda_handler(event, context):
    return get_all_tasks(event)

def get_all_tasks(event):
    client = boto3.resource("dynamodb")
    table = client.Table("Taskify")
    response = table.query(
        IndexName='username',
        KeyConditionExpression=
        Key('username').eq(event['queryStringParameters']['username']))
    return {
        "statusCode": 200,
        "headers": {
            "Access-Control-Allow-Origin": "*",
            'Access-Control-Allow-Headers': 'Content-Type',
            'Access-Control-Allow-Methods': 'OPTIONS,POST,GET'
        },
        "body": json.dumps(response['Items']),
        "isBase64Encoded": False
    }
