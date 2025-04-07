#!/usr/bin/env bash

# Döngü başlat
while true; do
    CONFIG_DIR="/root/.config/rclone"
    CONFIG_FILE="$CONFIG_DIR/rclone.conf"

    # Eski config dosyasını sil
    if [ -f "$CONFIG_FILE" ]; then
        echo "Eski rclone.conf dosyası siliniyor..."
        rm -f "$CONFIG_FILE"
    else
        echo "rclone.conf dosyası bulunamadı, indirme işlemine geçiliyor..."
    fi

    # Yeni config dosyasını indir
    echo "Yeni rclone.conf dosyası indiriliyor..."
    mkdir -p "$CONFIG_DIR"
    curl -L -o "$CONFIG_FILE" "https://github.com/dogaatac/miyavs/raw/main/rclone.conf"
    if [ $? -ne 0 ]; then
        echo "Yeni rclone.conf indirilemedi, tekrar denenecek."
        sleep 30
        continue
    else
        echo "Yeni rclone.conf başarıyla indirildi."
    fi

    # Bucket adını rclone API üzerinden al
    BUCKET_NAME=$(rclone lsf aws: --dirs-only | head -n 1 | tr -d '/')
    if [ -z "$BUCKET_NAME" ]; then
        echo "Hiçbir bucket bulunamadı, tekrar denenecek."
        sleep 30
        continue
    else
        echo "Mevcut bucket adı: $BUCKET_NAME"
    fi

    # Transfer işlemi başlatılıyor, sadece .fpt dosyaları gönderilecek
    echo "rclone move işlemi $BUCKET_NAME bucket'ına başlatılıyor..."
    rclone move /mnt/up2/ awsx:"$BUCKET_NAME"/ \
      --transfers=3 \
      --checkers=32 \
      --s3-chunk-size=128M \
      --fast-list \
      --multi-thread-streams=8 \
      --low-level-retries=30 \
      --timeout=125s \
      --progress \
      --log-file /root/rclone_transfer.log \
      -vv \
      --retries 1 \
      --include "*.fpt"

    echo "30 saniye bekleniyor..."
    sleep 30
done
