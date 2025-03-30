#!/bin/bash

# Kaynak ve hedef dizinler
SOURCE_DIR="/root/pw"
DEST_DIRS=("/mnt/up1" "/mnt/up2" "/mnt/up3")

while true; do
    # .fpt uzantılı dosyaları listele
    files=($(find "$SOURCE_DIR" -type f -name "*.fpt"))
    
    # Eğer gönderilecek dosya yoksa bekle ve devam et
    if [ ${#files[@]} -eq 0 ]; then
        echo "Gönderilecek .fpt dosyası bulunamadı."
    else
        for file in "${files[@]}"; do
            # Rastgele bir hedef dizin seç
            RANDOM_DEST=${DEST_DIRS[$RANDOM % ${#DEST_DIRS[@]}]}
            
            # Dosyayı hedef dizine taşı
            mv "$file" "$RANDOM_DEST"/
            echo "$file dosyası $RANDOM_DEST dizinine taşındı."
        done
    fi
    
    # 60 saniye bekle
    sleep 252
done
