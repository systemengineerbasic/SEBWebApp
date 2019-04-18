import os
from bottle import route, run, template, request
from datetime import datetime

@route("/")
def hello_world():
    now = datetime.now()
    return template('html_template', now=now, color='', scolor='')

@route("/", method='POST')
def push_signal():
    now = datetime.now()
    input_color = request.forms.input_color
    return template('html_template', now=now, color='', scolor=input_color)

run(host="0.0.0.0", port=int(os.environ.get("PORT", 5000)))