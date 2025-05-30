#!/bin/bash

# Kaynak ve hedef dizinler
SOURCE_DIRS=("/root/pw" "/mnt/pw")
DEST_DIRS=("/mnt/up1" "/mnt/up2" "/mnt/up3")

while true; do
    files=()
    
    # Tüm kaynak dizinlerde .fpt dosyalarını ara
    for src in "${SOURCE_DIRS[@]}"; do
        while IFS= read -r -d '' file; do
            files+=("$file")
        done < <(find "$src" -type f -name "*.fpt" -print0)
    done

    # Eğer gönderilecek dosya yoksa bekle ve devam et
    if [ ${#files[@]} -eq 0 ]; then
        echo "Gönderilecek .fpt dosyası bulunamadı."
    else
        for file in "${files[@]}"; do
            # Dosyanın temel adını al (uzantısız)
            base_name=$(basename "$file" .fpt)

            # Rastgele bir hedef dizin seç
            RANDOM_DEST=${DEST_DIRS[$RANDOM % ${#DEST_DIRS[@]}]}

            # Geçici dosya adı (örneğin .tmp uzantısıyla)
            temp_name="${base_name}.tmp"

            # Dosyayı geçici adla hedef dizine taşı
            mv "$file" "$RANDOM_DEST/$temp_name"

            # Eğer taşıma başarılıysa, .fpt uzantısını geri döndür
            if [ $? -eq 0 ]; then
                mv "$RANDOM_DEST/$temp_name" "$RANDOM_DEST/${base_name}.fpt"
                echo "$file dosyası $RANDOM_DEST/${base_name}.fpt olarak taşındı."
            else
                echo "Hata: $file taşınamadı."
            fi
        done
    fi

    # 111 saniye bekle
    sleep 111
done
