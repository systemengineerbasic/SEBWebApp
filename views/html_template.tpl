<html>
    <head>
        <title> シススク サンプル Web アプリケーション</title>
            <script src="https://cdnjs.cloudflare.com/ajax/libs/paho-mqtt/1.0.1/mqttws31.js" type="text/javascript">
            </script>
            <script type = "text/javascript" language = "javascript">
                var mqtt;
                var reconnectTimeout = 2000;
                var host = "m15.cloudmqtt.com";
                var port = 33415;

                function onConnect(){
                    document.getElementById("messages").innerHTML="Connected to "+host +"on port "+port;
                    connected_flag=1
                    document.getElementById("status").innerHTML = "Connected";
                    console.log("on Connect " +connected_flag);
                    mqtt.subscribe("KM/Signal");
                }

                function onMessageArrived(r_message){
                    out_msg="Message received "+r_message.payloadString+"<br>";
                    out_msg=out_msg+"Message received Topic ",r_message.destinationName;
                    //console.log("Message received ",r_message.payloadString);
                    console.log(out_msg);
                    document.getElementById("messages").innerHTML =out_msg;
                }

                function onConnected(recon,url){
                    console.log(" in onConnected "+reconn);
                }

                function MQTTconnect(){
                    console.log("connecting to "+ host +" "+ port);
                    mqtt = new Paho.MQTT.Client(host,port,"WebApp");
                    var options = {
                        useSSL:true,
                        timeout:3,
                        userName:"niccngso",
                        password:"6UKWREecCBYB",
                        onSuccess:onConnect,
                        onFailure: onFailure,
                    };
                    mqtt.onConnectionLost = onConnectionLost;
                    mqtt.onMessageArrived = onMessageArrived;
                    mqtt.onConnected = onConnected;
                    mqtt.connect(options); //connect
                    return false;
                }

                function send_messages(){
                    document.getElementById("messages").innerHTML="";
                    if (connected_flag==0){
                        out_msg="<b>Not Connected so can't send</b>"
                        console.log(out_msg);
                        document.getElementById("messages").innerHTML = out_msg;
                        return false;
                    }
                    var msg = document.forms["smessage"]["input_color"].value;
                    console.log(msg);
                    var topic = "KM/Signal";
                    //message = new Paho.MQTT.Message("{\"deviceName\":\"Webclient\",\"LED\":\"YELLOW\"}");
                    message = new Paho.MQTT.Message(msg);
                    message.destinationName = topic;
                    mqtt.send(message);
                    return false;
                }
            </script>
    </head>
    <body>
    <h2> シススク サンプル Web アプリケーション </h2>
        <script>
        MQTTconnect();
        </script>
    <div id="status">Connection Status: Not Connected</div>
    <p>
    <ul>
        <li> 現在の信号機は、{{color}] 色です</li>
        <li> 現在の時刻は {{now}} 。</li>
    </ul>
    </p>
    <figure>
    <legend> 信号機の状態 </legend>
    <img src="{{signalpic}}">
    </figure>
    <p>
    <form name="smessage" action="" onsubmit="return send_messages()">
        <input type="radio" name="input_color" value="{\"deviceName\":\"Webclient\",\"LED\":\"RED\"}"> 赤
        <input type="radio" name="input_color" value="{\"deviceName\":\"Webclient\",\"LED\":\"YELLOW\"}"> 黄
        <input type="radio" name="input_color" value="{\"deviceName\":\"Webclient\",\"LED\":\"BLUE\"}"> 青
        <input type="submit" value="Submit">
    </form>
    </p>
    <p>
    <form method="post" action="/">
        <input type="radio" name="input_color" value="RED"> 赤
        <input type="radio" name="input_color" value="YELLOW"> 黄
        <input type="radio" name="input_color" value="BLUE"> 青
        <input type="submit" value="MQTT_Publish">
    </form>
    </p>
    </br>
    信号機に {{scolor}} 色を指定しました。 <br>
    Messages:<p id="messages"></p>
    </body>
</html>