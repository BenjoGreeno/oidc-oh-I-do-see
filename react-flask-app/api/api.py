import time
from flask import Flask

app = Flask(__name__)

@app.route('/api/time')
def get_current_time():
    return {'time': time.time()}
@app.route('/backend')
def just_a_test():
    return {"I am a test from": "the backend blahblahblah!"}

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0')