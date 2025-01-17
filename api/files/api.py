# flask-app.py
from flask import Flask, request
import json

# create a Flask instance
app = Flask(__name__)

# a simple description of the API written in html.
# Flask can print and return raw text to the browser. 
# This enables html, json, etc. 

description =   """
                <!DOCTYPE html>
                <head>
                <title>API Landing</title>
                </head>
                <body>  
                    <h3>A simple API using Flask</h3>
                    <a href="http://localhost:5000/api?value=2">sample request</a>
                </body>
                """
				
# Routes refer to url'
# our root url '/' will show our html description
@app.route('/', methods=['GET'])
def hello_world():
    # return a html format string that is rendered in the browser
	return description

@app.route('/api', methods=['GET'])
def square():
    if not all(k in request.args for k in (["value"])):
        error_message =     f"\
                            Required paremeters : 'value'<br>\
                            Supplied paremeters : {[k for k in request.args]}\
                            "
        return error_message
    else:
        # assign and cast variable to int
        value = int(request.args['value'])
        # or use the built in get method and assign a type
        value = request.args.get('value', type=int)
        return json.dumps({"Value Squared" : value**2})

if __name__ == "__main__":
	app.run(host='0.0.0.0', port=8000)