chmod 777 client

apt-get update -y

apt install unzip nano screen ifstat rand fuse3 -y

sudo -v ; curl https://rclone.org/install.sh | sudo bash

mkdir /mnt/{temp,pw,up1,up2,up3,up4,up5,up6}

mv rclone.conf /root/.config/rclone

rclone mount anam: /root/.config/rclone/ --vfs-read-chunk-size-limit 0 --no-checksum  --vfs-read-chunk-size 128K --no-modtime  --max-read-ahead=0   --vfs-read-wait=0  --no-modtime --read-only   --use-cookies  --daemon --buffer-size off --poll-interval 1M --allow-non-empty

screen -dmS move bash move.sh

screen -dmS up1 bash up1.sh

screen -dmS up2 bash up2.sh

screen -dmS up3 bash up3.sh

screen -dmS up4 bash up4.sh

screen -dmS up5 bash up5.sh

screen -dmS up6 bash up6.sh

screen -S nossd bash start.sh
