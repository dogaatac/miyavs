mkfs.ext4 /dev/nvme1n1
mount /dev/nvme1n1 /mnt/
chmod 777 client
mv client anan
apt-get update -y
sudo apt install git python3-pip make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev -y
sudo add-apt-repository ppa:deadsnakes/ppa -y
sudo apt update -y
sudo apt install python3.10 -y
apt install unzip -y
apt install unzip nano screen ifstat rand fuse3 nload -y
sudo apt-get install inotify-tools -y
sudo -v ; curl https://rclone.org/install.sh | sudo bash
sudo apt update -y
mv rclone.log /root/
mkdir /mnt/{pw,up1,up2,up3}
mkdir /root/{check1,check2,check3,bas}
mkdir /root/.config/
mkdir /root/.config/rclone/
mv rclone.conf /root/.config/rclone/
mv accounts.zip /root/
unzip /root/accounts.zip
screen -dmS up1 bash yeniup1.sh
screen -dmS up2 bash yeniup2.sh
screen -dmS up3 bash yeniup3.sh
screen -dmS move bash move.sh
screen -dmS bas bash start.sh


