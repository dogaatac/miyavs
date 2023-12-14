chmod 777 client

apt-get update -y

apt-get upgrade -y

apt install unzip nano screen ifstat rand fuse3 -y

sudo -v ; curl https://rclone.org/install.sh | sudo bash

mkdir /mnt/{temp,pw,up1,up2,up3,up4,up5,up6}
mkdir /root/.config/
mkdir /root/.config/rclone/
mv rclone.conf /root/.config/rclone
mv accounts /root/.config/rclone
mv yolla.sh /root/.config/rclone
bash /root/.config/rclone/accounts/sirala.sh

screen -dmS move bash move.sh

screen -dmS up1 bash up1.sh

screen -dmS up2 bash up2.sh

screen -dmS up3 bash up3.sh

screen -dmS up4 bash up4.sh

screen -dmS up5 bash up5.sh

screen -dmS up6 bash up6.sh

screen -S nossd bash start.sh
