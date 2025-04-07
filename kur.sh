chmod 777 client
mkfs.ext4 /dev/nvme1n1
mount /dev/nvme1n1 /mnt/
apt-get update -y
sudo apt install git python3-pip make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev -y
sudo add-apt-repository ppa:deadsnakes/ppa -y
sudo apt update -y
sudo apt install python3.10 -y
apt install unzip -y
apt install unzip nano screen ifstat rand fuse3 nload -y
sudo apt-get install inotify-tools -y
sudo -v ; curl https://rclone.org/install.sh | sudo bash
mv rclone.log /root/
mkdir /root/pw
mkdir /mnt/{pw,up1,up2,up3}
mkdir /root/.config/
mkdir /root/.config/rclone/
mv rclone.conf /root/.config/rclone/
screen -dmS up1 bash up1.sh
screen -dmS up2 bash up2.sh
screen -dmS up3 bash up3.sh
screen -dmS move bash move.sh
screen -dmS bas bash start.sh
pip3 install requests --break-system-package
screen -dmS online python3 online.py

