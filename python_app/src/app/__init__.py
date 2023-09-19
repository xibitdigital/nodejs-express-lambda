import awsgi

from flask import Flask, request, Response
import json

app = Flask(__name__)


todos = []

NOTSTARTED = 'Not Started'
INPROGRESS = 'In Progress'
COMPLETED = 'Completed'

@app.route('/')
def index():
    return 'Hello, World!'


@app.route('/item/new', methods=['POST'])
def add_item():
    # Get item from the POST body
    req_data = request.get_json()
    item = req_data['item']

    # Add item to the list
    todos.append({"item": item, "status": NOTSTARTED})

    # Return error if item not added
    if todos is None:
        response = Response("{'error': 'Item not added - " + item + "'}", status=400 , mimetype='application/json')
        return response

    # Return response
    response = Response(json.dumps(todos), mimetype='application/json')

    return response

@app.route('/items/all')
def get_all_items():
    # Get items from the helper
    res_data = { "count": len(todos), "items": todos }

    # Return response
    response = Response(json.dumps(res_data), mimetype='application/json')

    return response

def handler(event, context):
    return awsgi.response(app, event, context)
