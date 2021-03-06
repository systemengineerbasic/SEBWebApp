import os
from bottle import route, run, template, request, static_file
from datetime import datetime

#static file を読み込み、/static/ フォルダー内のファイル *.png 等を、./static/*.png と返す。
@route('/static/<file_path:path>')
def server_static(file_path):
    return static_file(file_path,root='./static/')

@route("/")
def hello_world():
    now = datetime.now()
    return template('html_template', now=now)

@route("/", method='POST')
def push_signal():
    now = datetime.now()
    input_color = request.forms.input_color
    return template('html_template', now=now, scolor=input_color)

run(host="0.0.0.0", port=int(os.environ.get("PORT", 5000)))