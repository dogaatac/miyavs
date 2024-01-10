import os
import random
import subprocess
import time

def get_proxies():
    with open('proxyler.txt', 'r') as file:
        lines = file.readlines()
        proxies = []
        for line in lines:
            proxy = line.strip()
            if proxy.startswith("unset"):
                # Unset işlemi varsa direkt olarak eklenir
                proxies.append({"unset_http_proxy": "unset http_proxy", "unset_https_proxy": "unset https_proxy"})
            else:
                # HTTP ve HTTPS proxylerini ayırır
                http_proxy = f"http://{proxy}"
                https_proxy = f"https://{proxy}"
                proxies.append({"http_proxy": http_proxy, "https_proxy": https_proxy})
        return proxies

while True:
    try:
        selected_proxy = random.choice(get_proxies())

        # Rasgele seçilen proxy ayarlarını uygula
        if "http_proxy" in selected_proxy:
            os.environ['http_proxy'] = selected_proxy['http_proxy']
            os.environ['https_proxy'] = selected_proxy['https_proxy']
            proxy_info = selected_proxy['http_proxy']
        else:
            os.environ.pop('http_proxy', None)
            os.environ.pop('https_proxy', None)
            proxy_info = "unset"

        # Rclone config dosyasındaki "ac" ile başlayan satırları al
        with open('/root/.config/rclone/yolla.conf', 'r') as file:
            ac_lines = [line.strip() for line in file if line.startswith('[ac')]

        # Rasgele bir "ac" satırını seç
        selected_ac_line = random.choice(ac_lines)

        # Seçilen "ac" satırından acX kısmını al
        ac_name = selected_ac_line.split('[')[1].split(']')[0]

        # /root/.config/rclone/accounts/ klasöründe .json dosyalarını al
        json_files = [file for file in os.listdir('/root/.config/rclone/accounts/') if file.endswith('.json')]

        # Rasgele bir .json dosyasını seç
        selected_json_file = random.choice(json_files)

        # Bilgilendirme mesajı
        print(f"Transfer başlatılıyor: {ac_name} kullanılarak {selected_json_file} service account'uyla transfer ediliyor... (Kullanılan Proxy: {proxy_info})")

        # Rclone move komutunu oluştur
        command = f'rclone move /mnt/up1/ "{ac_name}": --log-file /root/rclone.log --progress  --config /root/.config/rclone/yolla.conf --drive-upload-cutoff=700G --drive-pacer-min-sleep=700ms --checksum --check-first --drive-acknowledge-abuse  --drive-stop-on-upload-limit --no-traverse --tpslimit-burst=0 --retries=1 --low-level-retries=1 --checkers=7 --tpslimit=3 --transfers=3 --fast-list --drive-stop-on-upload-limit --drive-chunk-size 128M --no-traverse --ignore-existing --log-level INFO --drive-service-account-file "/root/.config/rclone/accounts/{selected_json_file}" -P'

        # Komutu çalıştır
        subprocess.run(command, shell=True)

        # 1 dakika bekle
        print("1 dakika bekleniyor...")
        time.sleep(60)

    except Exception as e:
        # Hata durumunda bilgilendirme
        print(f"Hata oluştu: {e}")
        print("Bekleme başlatılıyor...")
        time.sleep(10)
