<html>
    <head>
        <title> シススク サンプル Web アプリケーション</title>
            <script src="https://cdnjs.cloudflare.com/ajax/libs/paho-mqtt/1.0.1/mqttws31.js" type="text/javascript">
            </script>
            <script type = "text/javascript" language = "javascript">
                var mqtt;
                var reconnectTimeout = 2000;
                var host = "m15.cloudmqtt.com"; //CloudMQTT のホスト URI
                var port = 33415;　//WebSockets Port (TLS で接続するため)

                function onConnectionLost(){
                    console.log("connection lost");
                    document.getElementById("status").innerHTML = "Connection Lost";
                    document.getElementById("messages").innerHTML = "Connection Lost";
                    connected_flag=0;
                }

                function onFailure(message){
                    console.log("Failed");
                    document.getElementById("messages").innerHTML = "Connection Failed - Retrying";
                    setTimeout(MQTTconnect, reconnectTimeout);
                }

                function onConnect(){
                    document.getElementById("messages").innerHTML="Connected to "+host+" on port "+port;
                    connected_flag=1
                    document.getElementById("status").innerHTML = "Connected to "+host+" on port "+port;
                    console.log("on Connect " +connected_flag);
                    mqtt.subscribe("KM/Signal");
                }

                function onMessageArrived(r_message){
                    out_msg = "TOPIC : " + r_message.destinationName + "<br>";
                    out_msg = out_msg + "Message : " + r_message.payloadString;
                    //console.log("Message received ",r_message.payloadString);
                    console.log(out_msg);
                    document.getElementById("messages").innerHTML = out_msg;
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
                        userName:"niccngso", //CloudMQTT の User 名
                        password:"6UKWREecCBYB", //CloudMQTT の Password
                        onSuccess:onConnect,
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
                    //JavaScript の時はダブルコーテーションの前にバックスラッシュで、エスケープ
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

    <p>
    現在の時刻： {{now}}
    <br> 
    CloudMQTT への接続状態
    <div id="status">Connection Status: Not Connected</div>
    <br>
    </p>

    CloudMQTT からの信号機の状態:<p id="messages"></p>

    <figure>
    <legend> 信号機の状態 </legend>
    <img src="{{signalpic}}">
    </figure>

    <p>
    CloudMQTT に強制的に信号の色を Publish
    <form name="smessage" action="" onsubmit="return send_messages()">
        <input type="radio" name="input_color" value="{&quot;deviceName&quot;:&quot;Webclient&quot;,&quot;LED&quot;:&quot;RED&quot;}"> 赤
        <input type="radio" name="input_color" value="{&quot;deviceName&quot;:&quot;Webclient&quot;,&quot;LED&quot;:&quot;YELLOW&quot;}"> 黄
        <input type="radio" name="input_color" value="{&quot;deviceName&quot;:&quot;Webclient&quot;,&quot;LED&quot;:&quot;BLUE&quot;}"> 青
        <br>
        <input type="submit" value="MQTT Publish">
    </form>
    </p>
    <p>

    <!-- post Method のフォームを Python に送るサンプル フォーム
    <form method="post" action="/">
        <input type="radio" name="input_color" value="RED"> 赤
        <input type="radio" name="input_color" value="YELLOW"> 黄
        <input type="radio" name="input_color" value="BLUE"> 青
        <input type="submit" value="MQTT_Publish">
    </form>
    </p>
    </br>
    信号機に {{scolor}} 色を指定しました。 <br>
    -->
    
    </body>
</html>