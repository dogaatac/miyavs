#!/usr/bin/env bash

echo -n "Lütfen bellek boyutunu girin (varsayılan 16): "
read -t 10 num  # Kullanıcıdan giriş bekler, 10 saniye içinde bir giriş yapılmazsa varsayılan değeri kullanır

if [ -z "$num" ]; then
    num=16  # Varsayılan bellek boyutu
fi

while true
do
    cd "$(dirname "$(realpath "${BASH_SOURCE[0]:-$0}")")"

    mem_value="${num}G"

    ./client -a xch16q8gxn8m8zs40fpfd6mja0hrdqwu9nna7newnww77sqjmudsa2tq89vzkk -d /mnt/pw/ --no-benchmark -c 14 --no-stop -vv -s /root/cache/ --no-mining --rescan-interval 60 -m "$mem_value"

    sleep 60
done
