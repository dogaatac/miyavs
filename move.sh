#!/bin/bash

counter=1

while [ true ]
do
    mv /mnt/pw/*.fpt /mnt/up$counter
    ((counter++))
    if [ $counter -gt 4 ]; then
        counter=1
    fi
    sleep 30
done
