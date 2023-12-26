import re
from collections import defaultdict
import requests
import time
from datetime import datetime, timedelta

log_file_path = "/root/rclone.log"
result_file_path = "sonuc.log"
discord_webhook_url = "https://discord.com/api/webhooks/1082696420043276438/IIWUID-XlOSzReMc59l6o3IhPhXjCTJMZp4IHKDWV6LXzSqWqEWZUTQd5LnbKq9Bq1HR"

machine_name = input("Makinanın adını girin: ")
hourly_price = float(input("Makinanın saatlik ücretini girin: "))

last_results = defaultdict(int)

while True:
    deleted_files_per_hour = defaultdict(int)
    total_files_deleted = 0

    # Geçerli zamanı al
    current_time = datetime.now()

    def count_deleted_files_per_hour(log_file):
        with open(log_file, "r") as file:
            for line in file:
                if "Deleted" in line:
                    match = re.search(r"(\d{4}/\d{2}/\d{2} \d{2}:\d{2}):\d{2}", line)
                    if match:
                        time_str = match.group(1)
                        log_time = datetime.strptime(time_str, "%Y/%m/%d %H:%M")
                        if current_time - log_time <= timedelta(days=1):
                            hour = log_time.hour
                            deleted_files_per_hour[hour] += 1

    count_deleted_files_per_hour(log_file_path)

    for hour in range(24):
        total_files_deleted += deleted_files_per_hour[hour]
        last_results[hour] = deleted_files_per_hour[hour]

    total_plots_sent = sum(last_results.values())

    with open(result_file_path, "w") as result_file:
        result_file.write(f"**{machine_name} **\n")
        for hour, deleted_files in last_results.items():
            if deleted_files != 0:  # Dosya silinmediyse bölme işlemi yapılacak
                hour_price = hourly_price / deleted_files
                result_file.write(f"Saat {hour:02}:00 - | plot: {deleted_files} |: {hour_price:.2f}\n")
            else:
                result_file.write(f" {hour:02}:00 - | : {deleted_files} | Ücret: 0\n")

        total_hourly_price = hourly_price * 24 / total_files_deleted if total_files_deleted != 0 else 0
        result_file.write(f"24 saat: {total_plots_sent} | ortalama: {total_hourly_price:.2f}\n")

    with open(result_file_path, "r") as result_file:
        current_result = result_file.read()
        payload = {
            "content": current_result,
            "username": machine_name,
        }
        headers = {"Content-Type": "application/json"}
        requests.post(discord_webhook_url, json=payload, headers=headers)
        print("Veri Discord'a gönderildi.")

    print("Sonuçlar sonuc.log dosyasına yazıldı. Bekleniyor...")
    
    # Bir saat bekleyin (3600 saniye)
    time.sleep(3600)
