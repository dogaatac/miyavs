#!/usr/bin/env bash

while true
do
    cd "$(dirname "$(realpath "${BASH_SOURCE[0]:-$0}")")"

       ./client -a xch16q8gxn8m8zs40fpfd6mja0hrdqwu9nna7newnww77sqjmudsa2tq89vzkk -d /mnt/pw/ --no-benchmark -c 14 --no-stop -vv -s /root/cache/ --no-mining --no-temp

    sleep 60
done
