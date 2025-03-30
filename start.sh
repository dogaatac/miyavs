#!/usr/bin/env bash

while true; do
   
    TOTAL_RAM=$(free -g | awk '/^Mem:/{print $2}')
    
       cd "$(dirname "$(realpath "${BASH_SOURCE[0]:-$0}")")"

        if [ "$TOTAL_RAM" -ge 110 ]; then
                ./client -d /mnt/pw/  -c 10 --no-stop -vv -s /root/cache/ --no-temp --no-mining --no-benchmark 
    else
        
        ./client -d,1N /mnt/pw/ -c 10  -vv -s /root/cache/ --no-mining --no-benchmark  --no-stop
    fi

    # 60 saniye bekle
    sleep 60
done
