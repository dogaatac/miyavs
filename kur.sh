chmod 777 client

apt-get update -y
sudo apt install git python3-pip make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev -y
sudo add-apt-repository ppa:deadsnakes/ppa -y
sudo apt update -y
sudo apt install python3.10 -y



apt install unzip nano screen ifstat rand fuse3 nload -y

sudo -v ; curl https://rclone.org/install.sh | sudo bash
sudo apt update -y


mkdir /mnt/{temp,pw,up1,up2,up3,up4,up5,up6}
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

screen -S bas bash start.sh
