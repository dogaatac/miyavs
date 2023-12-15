#!/bin/bash

try=0
userRateLimitExceededCount=0
slot=$((($RANDOM % 55) + 1))
file_count=$(ls /root/.config/rclone/accounts | wc -l)

while true
do
    index=$((($RANDOM % $file_count) + 1))
               
        rclone move /mnt/up3/ "ac$slot": --progress --config /root/.config/rclone/yolla.conf  --drive-upload-cutoff 700G --multi-thread-streams 32 --tpslimit 3 --drive-stop-on-upload-limit --drive-chunk-size 256M --no-traverse --ignore-existing --log-level INFO   --drive-service-account-file "/root/.config/rclone/accounts/$index.json" -P
        if [[ $? -eq 0 ]]; then
            echo -e "\e[3;32m Transfer Done ... \e[0m"
        else
            echo -e "\e[3;31m Transfer Failed ... \e[0m"
            if [[ $index -eq 1 ]]; then
                userRateLimitExceededCount=$(($userRateLimitExceededCount + 1))
            
        fi

        slot=$((slot % 55 + 1))
        echo "********************************************************"
    fi
        sleep 5
done
