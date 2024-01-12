import os
import random
import subprocess
import time

while True:
    try:
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

        # Proxy listesini dosyadan oku
        with open('/root/.config/rclone/proxyler.txt', 'r') as proxy_file:
            proxy_list = [line.strip() for line in proxy_file if line.strip()]

        # Belirli bir olasılıkla proxy kullanma kararı al
        use_proxy_probability = 0.5  # Örneğin, %50 olasılıkla proxy kullan
        use_proxy = random.random() < use_proxy_probability

        if use_proxy:
            # Rasgele bir proxy seç
            selected_proxy = random.choice(proxy_list)
            https_proxy = f'HTTPS_PROXY=http://{selected_proxy} '
        else:
            # Proxy kullanmayacaksa boş bir değer ata
            https_proxy = ''

        # Rclone move komutunu oluştur
        command = f'{https_proxy}rclone move /mnt/up8/ "{ac_name}": --log-file /root/rclone.log --progress --no-check-certificate --config /root/.config/rclone/yolla.conf --drive-upload-cutoff=700G --drive-pacer-min-sleep=700ms --checksum --check-first --drive-acknowledge-abuse --drive-stop-on-upload-limit --no-traverse --tpslimit-burst=0 --retries=1 --low-level-retries=1 --checkers=7 --tpslimit=2 --transfers=2 --fast-list --drive-stop-on-upload-limit --drive-chunk-size 128M --no-traverse --ignore-existing --log-level INFO --drive-service-account-file "/root/.config/rclone/accounts/{selected_json_file}" -P'

        # Bilgilendirme mesajı
        if use_proxy:
            print(f"Transfer başlatılıyor: {ac_name} kullanılarak {selected_json_file} service account'u ve proxy ({selected_proxy}) ile transfer ediliyor...")
        else:
            print(f"Transfer başlatılıyor: {ac_name} kullanılarak {selected_json_file} service account'u ile proxy kullanılmadan transfer ediliyor...")

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
