import re
from collections import defaultdict
import requests
import time
from datetime import datetime, timedelta

log_file_path = "/root/rclone.log"
result_file_path = "sonuc.log"
discord_webhook_url = "https://discord.com/api/webhooks/1082696420043276438/IIWUID-XlOSzReMc59l6o3IhPhXjCTJMZp4IHKDWV6LXzSqWqEWZUTQd5LnbKq9Bq1HR"

user_email = input("E-posta adresinizi girin: ")  # Sadece e-posta adresini sor

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
        result_file.write(f"Email: {user_email}\n")  # Sadece e-posta adresini ekle
        for hour, deleted_files in last_results.items():
            result_file.write(f"Saat {hour:02}:00 - | plot: {deleted_files}\n")

        result_file.write(f"24 saat: {total_plots_sent}\n")

    with open(result_file_path, "r") as result_file:
        current_result = result_file.read()
        payload = {
            "content": current_result,
            "username": "Log Report",  # Discord'da sabit bir isim kullanabilir
        }
        headers = {"Content-Type": "application/json"}
        requests.post(discord_webhook_url, json=payload, headers=headers)
        print("Veri Discord'a gönderildi.")

    print("Sonuçlar sonuc.log dosyasına yazıldı. Bekleniyor...")
    
    # Bir saat bekleyin (3600 saniye)
    time.sleep(3600)
