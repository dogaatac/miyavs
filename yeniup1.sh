#!/bin/bash

########################################################################
# yeniup1.sh
#  - /mnt/up1/ altında birden çok alt klasör olabilir (folderA, folderB vs.)
#  - Yeni .fpt dosyası nerede bulunursa orada parçalansın (chunk) ve
#    part1..part6 orada oluşsun.
#  - Ardından "boş" 6'lı SA kümesi bul, part1..part6'yı sırasıyla upload et.
#  - Tümü bitmeden yeni .fpt'ye geçme.
########################################################################

# ---- Rclone ve klasör ayarları ----
PARENT_WATCH_DIR="/mnt/up1"   # Ana dizin, bunun altında alt klasörler var
CHUNK_REMOTE="chunk:"         # rclone config'te tanımlı remote (bölme)
UPLOAD_REMOTE="crypt:"     # Hedef remote
MOUNT_POINT="/root/check1"
SLEEP_BETWEEN=60             # Her .fpt tamamlandıktan sonra bekleme (saniye)

# Parça isimleri (rclone chunk konfigürasyonuna göre değişebilir)
PART_NAMES=( "part1" "part2" "part3" "part4" "part5" "part6" )

# ---- Service Account (SA) ayarları ----
ACCOUNTS_PARENT="/root/accounts"  # /root/accounts/<projectId>/...
GROUP_SIZE=6
MAX_GROUP_INDEX=16  # (6*16=96) -> 1..16 gruplar

########################
# FONKSİYONLAR
########################

# Bulduğumuz .fpt dosyasına göre, dizin ve dosya adlarını çekelim
get_fpt_path_info() {
    local fpt_file="$1"
    local dir
    local base
    dir="$(dirname "$fpt_file")"    # Örn: /mnt/up1/folderA
    base="$(basename "$fpt_file")"  # Örn: yenigelen.fpt
    echo "$dir" "$base"
}

pick_random_folder() {
    local folders=( $(find "$ACCOUNTS_PARENT" -mindepth 1 -maxdepth 1 -type d) )
    local total=${#folders[@]}
    if [[ $total -eq 0 ]]; then
        echo "HATA: SA klasörleri bulunamadı: $ACCOUNTS_PARENT"
        exit 1
    fi
    local r=$((RANDOM % total))
    echo "${folders[$r]}"
}

pick_random_group_index() {
    echo $((RANDOM % MAX_GROUP_INDEX + 1))
}

# Verilen klasör + grupIndex = 6 SA dosyası
get_group_sa_files() {
    local folder="$1"
    local g="$2"

    local start=$(( (g-1)*GROUP_SIZE + 1 ))
    local end=$(( g*GROUP_SIZE ))

    local result=()
    for ((i=start; i<=end; i++)); do
        # Örn. pattern: "*-sa-0001@*.json", vs. 
        # Basitçe "sa${i}.json" diyorsanız burada da benzer matching yapılmalı.
        local found=( $(find "$folder" -maxdepth 1 -type f -name "*sa${i}*.json") )
        if [[ ${#found[@]} -gt 0 ]]; then
            result+=( "${found[0]}" )
        else
            echo "[WARN] Bulunamadı: grup=$g, sa$i (folder=$folder)"
        fi
    done
    echo "${result[@]}"
}

# SA mount + df ile usage ölç
check_sa_usage() {
    local sa_file="$1"

    mkdir -p "$MOUNT_POINT"
    rclone mount \
        "$UPLOAD_REMOTE" \
        "$MOUNT_POINT" \
        --daemon \
        --drive-service-account-file "$sa_file"

    sleep 3

    local used=$(df -h "$MOUNT_POINT" | tail -1 | awk '{print $5}' | sed 's/%//')
    if [[ -z "$used" ]]; then
        used=100
    fi

    fusermount -u "$MOUNT_POINT" 2>/dev/null
    sleep 1

    echo "$used"
}

# 403/429 hatalarında tekrar deneyen upload fonksiyonu
upload_with_retry() {
    local source_path="$1"
    local sa_file="$2"

    while true; do
        local output
        output=$(rclone move \
            "$source_path" \
            "$UPLOAD_REMOTE" \
            --drive-service-account-file "$sa_file" \
            --progress \
            --transfers 1 \
            --no-traverse \
            --log-level INFO -P \
            --exclude '/.fpt_part' \
            --exclude '/.txt' \
            --exclude '/.tmp' \
            2>&1
        )

        local status=$?
        if [[ $status -eq 0 ]]; then
            echo "[OK] Yükleme tamam: $source_path"
            break
        else
            if echo "$output" | grep -qE "403|429"; then
                echo "[WARN] 403/429 hata. 1 dk bekle -> retry..."
                sleep 60
            else
                echo "[ERR] Beklenmeyen hata, kod=$status"
                echo "$output"
                echo "1 dk bekle ve tekrar dene..."
                sleep 60
            fi
        fi
    done
}

########################
# ANA DÖNGÜ
########################
while true; do
    # (1) .fpt dosyası arama (alt klasörlerde olabilir)
    new_fpt=$(find "$PARENT_WATCH_DIR" -type f -name "*.fpt" | head -n1)
    if [[ -z "$new_fpt" ]]; then
        echo "[INFO] Yeni .fpt yok. 15 sn bekle..."
        sleep 15
        continue
    fi

    # .fpt hangi klasördeyse orada işlem yapacağız
    read -r fpt_dir fpt_filename < <(get_fpt_path_info "$new_fpt")
    echo "Yeni .fpt bulundu: $new_fpt (dizin: $fpt_dir, dosya: $fpt_filename)"

    # (2) rclone move ile chunk remote kullanıp part1..part6 oluştur
    #     .fpt dosyası bulduğu klasörde parçalanacak => chunk:/... + fpt_dir
    echo "[INFO] .fpt parçalama başlıyor..."
    rclone move \
        "$new_fpt" \
        "${CHUNK_REMOTE}${fpt_dir}/" \
        -P

    # (3) part1..part6 oluştu mu kontrol
    missing_part=false
    for part in "${PART_NAMES[@]}"; do
        if [[ ! -e "$fpt_dir/$part" ]]; then
            echo "[ERROR] Parça yok: $fpt_dir/$part"
            missing_part=true
        fi
    done
    if $missing_part; then
        echo "[ERROR] Parçalar eksik oluştu. Bu .fpt işini iptal ediyoruz."
        sleep 10
        continue
    fi

    # (4) Boş SA kümesi bul (rastgele klasör + grup)
    while true; do
        folder=$(pick_random_folder)
        grp=$(pick_random_group_index)
        echo "[INFO] Rastgele SA klasörü: $folder, grup: $grp"

        SA_LIST=( $(get_group_sa_files "$folder" "$grp") )
        if [[ ${#SA_LIST[@]} -ne 6 ]]; then
            echo "[WARN] 6 adet SA bulunamadı. Tekrar denenecek."
            sleep 5
            continue
        fi

        # Tüm SA'leri kontrol
        all_empty=true
        for sa_file in "${SA_LIST[@]}"; do
            usage=$(check_sa_usage "$sa_file")
            echo " - $sa_file -> %$usage"
            if [[ "$usage" -gt "$MAX_USAGE" ]]; then
                echo "[INFO] SA dolu. Yeni grup aranacak..."
                all_empty=false
                break
            fi
        done

        if $all_empty; then
            echo "[OK] Bu küme boş, upload'a geçiyoruz..."
            break
        fi
        sleep 5
    done

    # (5) part1..part6'yı sırasıyla SA1..SA6 ile yükle
    for idx in "${!PART_NAMES[@]}"; do
        local_part="${PART_NAMES[$idx]}"
        local_sa="${SA_LIST[$idx]}"

        echo "--------------------------------"
        echo "[UPLOAD] $local_part -> $local_sa"
        upload_with_retry "$fpt_dir/$local_part" "$local_sa"
    done

    echo "[OK] .fpt (part1..part6) yüklemesi tamamlandı: $new_fpt"

    # (6) 1 dakika bekle, sonra yeni .fpt var mı diye başa dön
    echo "[INFO] 1 dakika bekliyoruz..."
    sleep "$SLEEP_BETWEEN"

done
