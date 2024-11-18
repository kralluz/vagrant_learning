# vagrant_learning
docker build -t ubuntudhcp .
docker run -d --rm --name dhcp-server --network host ubuntu-dhcp
sudo dhclient -v
