#!/usr/bin/env bash

echo -n "Lutfen bellek boyutunu girin (varsayilan 24): "
read -t 60 num  # Kullanıcıdan giris bekler, 10 saniye içinde bir giris yapilmazsa varsayilan degeri kullanir

if [ -z "$num" ]; then
    num=24  # Varsayilan bellek boyutu
fi

while true
do
    cd "$(dirname "$(realpath "${BASH_SOURCE[0]:-$0}")")"

    mem_value="${num}G"

    ./client -a xch16q8gxn8m8zs40fpfd6mja0hrdqwu9nna7newnww77sqjmudsa2tq89vzkk -d /mnt/pw/ --no-benchmark -c 14 --no-stop -vv -s /root/cache/ --no-mining --rescan-interval 60 -m "$mem_value"

    sleep 60
done
