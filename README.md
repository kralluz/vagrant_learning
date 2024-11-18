# vagrant_learning
|||||||||
docker build -t ubuntudhcp .
|||||||||
docker run -d --rm --name dhcp-server --network host ubuntu-dhcp
|||||||||
docker run -it --rm --network host ubuntu bash
|||||||||
apt update
apt install -y net-tools dnsutils
|||||||||
ifconfig
nslookup example.com
|||||||||
