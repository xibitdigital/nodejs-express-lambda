import awsgi

from flask import Flask, request
import json

app = Flask(__name__)


todos = []

NOTSTARTED = 'Not Started'
INPROGRESS = 'In Progress'
COMPLETED = 'Completed'

def response(status_code, data):
    return {
        "StatusCode": 200,
        "headers": {
            "Content-Type": "application/json"
        },
        "body": json.dumps(data)
    }


@app.route('/')
def index():
    data = 'Hello World!'

    return response(200, data)

@app.route('/item/new', methods=['POST'])
def add_item():
    # Get item from the POST body
    req_data = request.get_json()
    item = req_data['item']

    # Add item to the list
    todos.append({"item": item, "status": NOTSTARTED})

    # Return error if item not added
    if todos is None:
        data = {'error': 'Item not added - " + item + "'}

        return response(400, json.dumps(data))

    # Return response
    return response(200, json.dumps(todos))

@app.route('/items/all')
def get_all_items():
    # Get items from the helper
    res_data = { "count": len(todos), "items": todos }

    # Return response
    
    return response(200, json.dumps(res_data))


def handler(event, context):
    return awsgi.response(app, event, context)
