import re
from collections import defaultdict
import time
import requests

log_file_path = "/root/rclone.log"
result_file_path = "sonuc.log"
discord_webhook_url = "https://discord.com/api/webhooks/1082696420043276438/IIWUID-XlOSzReMc59l6o3IhPhXjCTJMZp4IHKDWV6LXzSqWqEWZUTQd5LnbKq9Bq1HR"

machine_name = input("Makinanın adını girin: ")
hourly_price = float(input("Makinanın saatlik ücretini girin: "))

last_result = ""

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

    files_1_hour = last_hour_files
    average_1_hour = hourly_price / files_1_hour if files_1_hour != 0 else 0

    files_6_hours = sum(deleted_files_per_hour[hour] for hour in range(1, 7))
    average_6_hours = hourly_price / (files_6_hours / 6) if files_6_hours != 0 else 0

    files_24_hours = sum(deleted_files_per_hour[hour] for hour in range(1, 25))
    average_24_hours = hourly_price / (files_24_hours / 24) if files_24_hours != 0 else 0

    with open(result_file_path, "w") as result_file:
        result_file.write("**Son 1 saatte yollanan plotlar**\n")
        result_file.write(f"**: {files_1_hour}**\n")
        result_file.write(f"**1 Saatlik Ortalama Dosya Başına Ücret: {average_1_hour}**\n")
        result_file.write(f"**6 Saatlik Ortalama Dosya Başına Ücret: {average_6_hours}**\n")
        result_file.write(f"**24 Saatlik Ortalama Dosya Başına Ücret: {average_24_hours}**\n")

    with open(result_file_path, "r") as result_file:
        current_result = result_file.read()
        if current_result != last_result:
            last_result = current_result
            payload = {
                "content": current_result,
                "username": machine_name,
            }
            headers = {"Content-Type": "application/json"}
            requests.post(discord_webhook_url, json=payload, headers=headers)
            print("Yeni veri Discord'a gönderildi.")

    print("Sonuçlar sonuc.log dosyasına yazıldı. Bekleniyor...")
    time.sleep(3600)
