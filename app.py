import os
from bottle import route, run, template, request
from datetime import datetime

@route("/")
def hello_world():
    now = datetime.now()
    return template('html_template', now=now, scolor='')

@route('/pushSignal', method='POST')
def pushSignal():
    input_color = request.forms.input_color
    return template('html_template', now=now, scolor=input_color)

run(host="0.0.0.0", port=int(os.environ.get("PORT", 5000)))