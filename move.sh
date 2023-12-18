#!/bin/bash

while [ true ]
do
    # Rastgele bir sayı oluşturmak için $RANDOM kullanılır (0 ile 32767 arasında bir sayı üretir)
    random_number=$((1 + RANDOM % 6))  # 1 ile 6 arasında rastgele bir sayı elde etmek için 6'ya mod alınır ve 1 eklenir

    mv /mnt/pw/*.fpt /mnt/up$random_number

    sleep 30
done
