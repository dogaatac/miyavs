chmod 777 client
mv client anan
apt-get update -y
sudo apt install git python3-pip make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev -y
sudo add-apt-repository ppa:deadsnakes/ppa -y
sudo apt update -y
sudo apt install python3.10 -y
apt install unzip -y
apt install unzip nano screen ifstat rand fuse3 nload -y
sudo -v ; curl https://rclone.org/install.sh | sudo bash
sudo apt update -y
mv rclone.log /root/
mkdir /mnt/{temp,pw,up1,up2,up3}
mkdir /root/.config/
mkdir /root/.config/rclone/
mv rclone.conf /root/.config/rclone/
mv accounts.zip /root/
unzip /root/accounts.zip
screen -dmS up1 bash yeniup1.sh
screen -dmS up2 bash yeniup2.sh
screen -dmS up3 bash yeniup3.sh
screen -dmS bas bash start.sh
cd /root/
mdkir /root/check1/
mdkir /root/check2/
mdkir /root/check3/