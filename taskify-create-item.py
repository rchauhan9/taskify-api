import boto3
import uuid
import json

def lambda_handler(event, context):
    return create_task(event)

def create_task(event):
    client = boto3.resource("dynamodb")
    table = client.Table("Taskify")
    task = generate_task_object(json.loads(event['body']))

    if not task:
        return empty_body_response()

    response = table.put_item(Item=task)
    return create_response(response, task)

def generate_task_object(body):
    if body:
        task = {
            "id": str(uuid.uuid4()),
            "username": body["username"],
            "title": body["title"],
            "notes": body["notes"],
            "deadline": body["deadline"],
            "completed": body["completed"],
        }
        return task

    return None

def empty_body_response():
    return {
        "statusCode": 400,
        "headers": { },
        "body": json.dumps({"message": "Error: Cannot create task from empty object."}),
        "isBase64Encoded": False
    }

def create_response(response, task):
    return {
        "statusCode": response['ResponseMetadata']["HTTPStatusCode"],
        "headers": {
            "Access-Control-Allow-Origin": "*",
            'Access-Control-Allow-Headers': 'Content-Type',
            'Access-Control-Allow-Methods': 'OPTIONS,POST,GET'
        },
        "body": json.dumps(task),
        "isBase64Encoded": False
    }
