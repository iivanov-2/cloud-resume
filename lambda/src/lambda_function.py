import json
import boto3
from itertools import count

client = boto3.client('dynamodb')

def lambda_handler(event, context):
    # TODO implement

    response = client.update_item(
        TableName='VisitCount',
        Key = {
            'id': {
                'N': '1'
            }
        },
        UpdateExpression = 'ADD CountNumber :inc',
        ExpressionAttributeValues={':inc':{'N':'1'}},
        ReturnValues='UPDATED_NEW'
    )

    return {
        'statusCode': 200,
        'body': json.dumps(response['Attributes']['CountNumber']['N'])
    }

    # return response['Attributes']['CountNumber']['N']