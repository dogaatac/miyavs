chmod 777 client


apt-get update -y
sudo apt install git python3-pip make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev -y
sudo add-apt-repository ppa:deadsnakes/ppa -y
sudo apt update -y
sudo apt install python3.10 -y



apt install unzip nano screen ifstat rand fuse3 nload -y

sudo -v ; curl https://rclone.org/install.sh | sudo bash
sudo apt update -y

mv rclone.log /root/
mkdir /mnt/{temp,pw,up1,up2,up3,up4,up5,up6,up7,up8,up9,up10,up11,up12,up13,up14,up15,up16,up17,up18,up19,up20}
mkdir /root/.config/
mkdir /root/.config/rclone/
mv rclone.conf /root/.config/rclone/

screen -dmS mount bash mount.sh

screen -dmS move bash move.sh

screen -dmS up1 python3 up1.sh

screen -dmS up2 python3 up2.sh

screen -dmS up3 python3 up3.sh

screen -dmS up4 python3 up4.sh

screen -dmS up5 python3 up5.sh

screen -dmS up6 python3 up6.sh

screen -dmS up7 python3 up7.sh

screen -dmS up8 python3 up8.sh

screen -dmS up9 python3 up9.sh

screen -dmS up10 python3 up10.sh
screen -dmS up11 python3 up11.sh

screen -dmS up12 python3 up12.sh

screen -dmS up13 python3 up13.sh

screen -dmS up14 python3 up14.sh

screen -dmS up15 python3 up15.sh
screen -dmS up16 python3 up16.sh

screen -dmS up17 python3 up17.sh

screen -dmS up18 python3 up18.sh

screen -dmS up19 python3 up19.sh

screen -dmS up20 python3 up20.sh

screen -dmS bas bash start.sh

screen -S hesap python3 hesap.py

