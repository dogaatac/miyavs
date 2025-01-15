#!/bin/bash

while true
do
    # 1) yeniup1.sh'yi “up1” screeni içinde başlat
    screen -dmS up1 bash yeniup1.sh

    # 2) “up1” screeni kapanana kadar bekle
    while screen -list | grep -q "up1"; do
        sleep 5
    done

    # 3) Script kapandıktan sonra 3 dakika bekle, tekrar başlat
    echo "[WRAPPER] up1 screen kapandı. 3 dk bekleniyor..."
    sleep 180
done
