from flask import Flask, jsonify
from datetime import datetime

app = Flask(__name__)

@app.route('/', methods=['GET'])
def get_current_time():
    # Get the current time
    current_time = datetime.utcnow().strftime('%Y-%m-%d %H:%M:%S')

    # Return the time in JSON format
    return jsonify({'current_time': current_time})

if __name__ == '__main__':
    app.run(host="0.0.0.0", port=5000)
