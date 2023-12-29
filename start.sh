#!/usr/bin/env bash

while true
do
    cd "$(dirname "$(realpath "${BASH_SOURCE[0]:-$0}")")"

       ./client -d /mnt/pw/ -c 14 --no-stop -vv -s /root/cache/ --no-temp

    sleep 60
done
