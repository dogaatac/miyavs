while true
do
    random_sleep=$((1 + RANDOM % 30))  # 1 ile 30 arasında rastgele bir sayı oluşturur

    mv /mnt/pw/*.fpt /mnt/up$((1 + RANDOM % 20))  # Dosyaları rastgele bir "up" klasörüne taşır

    sleep $random_sleep  # Rasgele oluşturulan süre kadar bekleme yapar
done
