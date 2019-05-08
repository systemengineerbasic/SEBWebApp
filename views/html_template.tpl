<html>
    <body>
    <h2> シススク サンプル Web アプリケーション </h2>
    <p>
    <ul>
        <li> 現在の信号機は、{{color}] 色です</li>
        <li> 現在の時刻は {{now}} 。</li>
    </ul>
    </p>
    <figure>
    <legend> 信号機の状態 </legend>
    <img src="./static/signal_full.png">
    </figure>
    <form method="post" action="/">
        <input type="text" name="input_color">
        <input type="submit" value="MQTT_Publish">
    </form>
    </br>
    信号機に {{scolor}} 色を指定しました。 
    </body>
</html>