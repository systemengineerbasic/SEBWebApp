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
    <p>
    <form method="post" action="/">
        <input type="radio" name="input_color" value="RED"> 赤
        <input type="radio" name="input_color" value="YELLOW"> 黄
        <input type="radio" name="input_color" value="BLUE"> 青
        <input type="submit" value="MQTT_Publish">
    </form>
    </p>
    </br>
    信号機に {{scolor}} 色を指定しました。 
    </body>
</html>