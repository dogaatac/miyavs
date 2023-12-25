import re
from collections import defaultdict
import time
import requests  # Webhook için requests kütüphanesini kullanacağız

log_file_path = "/root/rclone.log"
result_file_path = "sonuc.log"
discord_webhook_url = "https://discord.com/api/webhooks/1082696420043276438/IIWUID-XlOSzReMc59l6o3IhPhXjCTJMZp4IHKDWV6LXzSqWqEWZUTQd5LnbKq9Bq1HR"

machine_name = input("Makinanın adını girin: ")
hourly_price = float(input("Makinanın saatlik ücretini girin: "))

last_result = ""  # Son sonucu saklamak için değişken

while True:
    deleted_files_per_hour = defaultdict(int)

    def count_deleted_files_per_hour(log_file):
        with open(log_file, "r") as file:
            for line in file:
                if "Deleted" in line:
                    match = re.search(r"\d{4}/\d{2}/\d{2} (\d{2}):\d{2}:\d{2}", line)
                    if match:
                        hour = int(match.group(1))
                        deleted_files_per_hour[hour] += 1

    count_deleted_files_per_hour(log_file_path)

    last_hour_files = deleted_files_per_hour[max(deleted_files_per_hour, key=int)]

    files_1_hour = sum(deleted_files_per_hour[hour] for hour in range(60))  # Son 1 saat içindeki dosya silme sayısı
    average_1_hour = 0 if last_hour_files == 0 else hourly_price / last_hour_files  # Hesaplama düzeltiliyor

    files_6_hours = sum(deleted_files_per_hour[hour] for hour in range(6))
    average_6_hours = 0 if files_6_hours == 0 else hourly_price * 6 / files_6_hours

    files_24_hours = sum(deleted_files_per_hour[hour] for hour in range(24))
    average_24_hours = 0 if files_24_hours == 0 else hourly_price * 24 / files_24_hours

    with open(result_file_path, "w") as result_file:
        result_file.write("**Son 1 saatte yollanan plotlar**\n")
        result_file.write(f"**Son 1 saatteki ortalama ücret: {last_hour_files}**\n")
        result_file.write(f"**1 Saatlik Ortalama ücret: {average_1_hour}**\n")
        result_file.write(f"**6 Saatlik Ortalama ücret: {average_6_hours}**\n")
        result_file.write(f"**24 Saatlik Ortalama ücret: {average_24_hours}**\n")

    # Sonuçları kontrol et ve değişiklik varsa Discord Webhook'a gönder
    with open(result_file_path, "r") as result_file:
        current_result = result_file.read()
        if current_result != last_result:  # Yeni veri geldiyse
            last_result = current_result
            payload = {
                "content": current_result,
                "username": machine_name,
            }
            headers = {"Content-Type": "application/json"}
            requests.post(discord_webhook_url, json=payload, headers=headers)
            print("Yeni veri Discord'a gönderildi.")

    print("Sonuçlar sonuc.log dosyasına yazıldı. Bekleniyor...")
    time.sleep(3600)  # Her saat bekleyin (3600 saniye)