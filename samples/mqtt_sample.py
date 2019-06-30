import paho.mqtt.client as mqtt
import os
from urllib.parse import urlparse

# Set CloudMQTT environment information
broker_url = "m15.cloudmqtt.com"
port = 13415
user = "niccngso"
password = "6UKWREecCBYB"

# Define event callbacks
def on_connect(client, userdata, flags, rc):
    print("rc: " + str(rc))

def on_message(client, obj, msg):
    print(msg.topic + " " + str(msg.qos) + " " + str(msg.payload))

def on_publish(client, obj, mid):
    print("mid: " + str(mid))

def on_subscribe(client, obj, mid, granted_qos):
    print("Subscribed: " + str(mid) + " " + str(granted_qos))

def on_log(client, obj, level, string):
    print(string)

mqttc = mqtt.Client("WebApp")
# Assign event callbacks
mqttc.on_message = on_message
mqttc.on_connect = on_connect
mqttc.on_publish = on_publish
mqttc.on_subscribe = on_subscribe

# Parse CLOUDMQTT_URL (or fallback to localhost)
# MQTT topic and message: KM/Signal	{"deviceName":"Signal01","LED":"YELLOW"}
# url_str = os.environ.get('CLOUDMQTT_URL', 'mqtt://localhost:1883')
# url = urlparse.urlparse(url_str)
topic = 'KM/Signal'
pubtopic = 'KM/WebApp'

# Connect
# mqttc.username_pw_set("cloudMQTTのユーザ名", password="cloudMQTTのパスワード")
# mqttc.connect("cloudMQTTのURL", ポート番号)
# mqttc.username_pw_set(url.username, url.password)
# mqttc.connect(url.hostname, url.port)
mqttc.username_pw_set(user, password=password)
mqttc.connect(broker_url, port=port)

# Start subscribe
mqttc.subscribe(topic)

# Publish a message
# mqttc.publish(pubtopic, "Test Message from mqtt_sample.py")

# Continue the network loop, exit when an error occurs
rc = 0
while rc == 0:
    rc = mqttc.loop()
print("rc: " + str(rc))