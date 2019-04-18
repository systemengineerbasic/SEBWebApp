import os
from bottle import route, run, template
from datetime import datetime

@route("/")
def hello_world():
    now = datetime.now()
    return template('html_template', now=now)

run(host="0.0.0.0", port=int(os.environ.get("PORT", 5000)))