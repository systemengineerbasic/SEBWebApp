<html lang="ja">
    <head>
        <meta charset="UTF-8">
        <title> シススク サンプル Web アプリケーション</title>
            <script src="https://cdnjs.cloudflare.com/ajax/libs/paho-mqtt/1.0.1/mqttws31.js" type="text/javascript">
            </script>
            <script type = "text/javascript" language = "javascript">
                var mqtt;
                var reconnectTimeout = 2000;
                var host = "m10.cloudmqtt.com"; //CloudMQTT のホスト URI
                var port = 34519;　//WebSockets Port (TLS で接続するため)

                function onConnectionLost(){
                    console.log("MQTT サーバーへのコネクションが切れました");
                    document.getElementById("status").innerHTML = "MQTT サーバーへの接続が切れました";
                    document.getElementById("messages").innerHTML = "MQTT サーバーへの接続が切れました";
                    connected_flag=0;
                }
                function onFailure(message){
                    console.log("Failed");
                    document.getElementById("messages").innerHTML = "Connection Failed - Retrying";
                    setTimeout(MQTTconnect, reconnectTimeout);
                }
                function onMessageArrived(r_message){
                    //out_msg="TOPIC : "+r_message.destinationName+"<br>";
                    out_msg="Message : "+r_message.payloadString;
                    console.log("Message received ",r_message.payloadString);
                    console.log(out_msg);
                    document.getElementById("messages").innerHTML = out_msg;
                    //受け取ったMQTT Message を JSON 形式でパースする
                    json = JSON.parse(r_message.payloadString);
                    //console.log(json.deviceName);
                    console.log(json.Signal);
                    if(json.Signal == "BLUE") {
                        document.getElementById("trafic_signal").src = "./static/signal_blue.png";
                    }
                    else if (json.Signal == "YELLOW"){
                        document.getElementById("trafic_signal").src = "./static/signal_yellow.png";
                    }
                    else if (json.Signal == "RED"){
                        document.getElementById("trafic_signal").src = "./static/signal_red.png";
                    }else{
                        document.getElementById("trafic_signal").src = "./static/signal_full.png";
                    }
                }
                function onConnected(recon,url){
                    console.log(" in onConnected "+reconn);
                }
                function onConnect(){
                    console.log("Connected");
                    document.getElementById("messages").innerHTML="Connected to "+host+" on port "+port;
                    connected_flag=1;
                    document.getElementById("status").innerHTML="Connected";
                    console.log("on Connect "+connected_flag);
                    mqtt.subscribe("KM/Signal");
                }
                function disconnect(){
                    if(connected_flag==1)
                        mqtt.disconnect();
                }
                function MQTTconnect(){
                    console.log("connecting to "+ host +" "+ port);
                    mqtt = new Paho.MQTT.Client(host,port,"webapp");
                    var options = {
                        useSSL:true,
                        timeout: 3,
                        userName:"rkinkmdk",
                        password:"IAzU6d_IdX0W",
                        onSuccess: onConnect,
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
                    //JavaScript の時はダブルコーテーションの前にバックスラッシュで、エスケープ
                    message = new Paho.MQTT.Message(msg);
                    message.destinationName = topic;
                    mqtt.send(message);
                    return false;
                }
                function clickBtn(color){
                    var json_msg = "{\"deviceName\":\"Webclient\",\"Signal\":\"" + color + "\"}";
                    var topic = "KM/Signal";
                    console.log(json_msg);
                    message = new Paho.MQTT.Message(json_msg);
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
    </p> 

    CloudMQTT 接続 Status： <div id="status">Connection Status: Not Connected</div>
    <br>

    信号機の状態：<p id="messages"></p>

    <figure>
    <legend> 信号機 </legend>
    <img id="trafic_signal" src="./static/signal_full.png">
    </figure>
    <br>

    <p>
    CloudMQTT に強制的に信号の色を Publish<BR>
    <input type="button" value="青" onclick="clickBtn(&quot;BLUE&quot;)" style="color:#ffffff;background-color:#4EE27F;WIDTH:40px; HEIGHT:40px;"/>
    <input type="button" value="黄" onclick="clickBtn(&quot;YELLOW&quot;)" style="color:#000000;background-color:#FFFF00;WIDTH:40px; HEIGHT:40px;"/>
    <input type="button" value="赤" onclick="clickBtn(&quot;RED&quot;)" style="color:#ffffff;background-color:#FF0000;WIDTH:40px; HEIGHT:40px;"/>
    <input type="button" value="自動" onclick="clickBtn(&quot;AUTO&quot;)" style="color:#000000;background-color:#808080;WIDTH:80px; HEIGHT:40px;"/>
    </p>
    <p>

    <!-- 
        post Method のフォームを Python に送るサンプル フォーム
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