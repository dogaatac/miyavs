#!/bin/bash

# Dosya adı
dosya="proxyler.txt"

# Kullanıcıdan girdi al
read -p "Silmek istediğiniz kısmı seçin (vegas veya new): " secim

# vegas veya new'e göre işlem yap
case $secim in
  vegas)
    # vegas'in altındaki satırları silme
    awk '/^new=/{exit} {print} /^vegas=/{getline; next}' "$dosya" > temp.txt
    mv temp.txt "$dosya"
    echo "vegas ve altındaki satırlar silindi."
    ;;
  new)
    # new'in altındaki satırları silme
    awk '/^vegas=/{exit} {print} /^new=/{getline; next}' "$dosya" > temp.txt
    mv temp.txt "$dosya"
    echo "new ve altındaki satırlar silindi."
    ;;
  *)
    echo "Hatalı giriş. 'vegas' veya 'new' giriniz."
    ;;
esac

# Geri kalan scripti ekleyelim
# Örneğin, proxy listesini kontrol etme veya başka işlemler...

# Scripti kaydet
cat "$dosya"
