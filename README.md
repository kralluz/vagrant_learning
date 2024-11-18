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


saida esperada deve ser semelhante a:


root@maquina3:/# ifconfig
nslookup example.com
docker0: flags=4099<UP,BROADCAST,MULTICAST>  mtu 1500
        inet 172.17.0.1  netmask 255.255.0.0  broadcast 172.17.255.255
        inet6 fe80::42:b8ff:fe32:1eb1  prefixlen 64  scopeid 0x20<link>
        ether 02:42:b8:32:1e:b1  txqueuelen 0  (Ethernet)
        RX packets 24346  bytes 1073523 (1.0 MB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 26143  bytes 662928663 (662.9 MB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

enp0s3: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 10.0.2.15  netmask 255.255.255.0  broadcast 10.0.2.255
        inet6 fd00::da85:25c0:51e8:8b94  prefixlen 64  scopeid 0x0<global>
        inet6 fd00::7203:4533:303:9435  prefixlen 64  scopeid 0x0<global>
        inet6 fd00::aed1:6933:653a:7da2  prefixlen 64  scopeid 0x0<global>
        inet6 fe80::b1b0:744f:5b69:bc44  prefixlen 64  scopeid 0x20<link>
        inet6 fd00::21c8:5e35:4f30:dc4d  prefixlen 64  scopeid 0x0<global>
        inet6 fd00::24f8:b70a:389e:521c  prefixlen 64  scopeid 0x0<global>
        inet6 fd00::8726:cd16:8337:bc79  prefixlen 64  scopeid 0x0<global>
        ether 08:00:27:0c:b2:ab  txqueuelen 1000  (Ethernet)
        RX packets 2593931  bytes 3734063462 (3.7 GB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 289710  bytes 31224739 (31.2 MB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
        inet 127.0.0.1  netmask 255.0.0.0
        inet6 ::1  prefixlen 128  scopeid 0x10<host>
        loop  txqueuelen 1000  (Local Loopback)
        RX packets 10742  bytes 1141460 (1.1 MB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 10742  bytes 1141460 (1.1 MB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

Server:		127.0.0.53
Address:	127.0.0.53#53

Non-authoritative answer:
Name:	example.com
Address: 93.184.215.14
Name:	example.com
Address: 2606:2800:21f:cb07:6820:80da:af6b:8b2c





A interface enp0s3 tem o seguinte IP atribuído:

inet 10.0.2.15  netmask 255.255.255.0  broadcast 10.0.2.255

Esse IP está na faixa 10.0.2.x, que é uma faixa privada, de acordo com as sub-redes privadas definidas pelo padrão RFC 1918. Isso indica que o IP foi atribuído a partir de um servidor DHCP local. Em redes privadas, como é o caso de um ambiente de rede interna (sem IPs públicos), o servidor DHCP está, de fato, atribuindo um IP local à sua máquina.
|||||||||||||

Server: 127.0.0.53
Address: 127.0.0.53#53

Non-authoritative answer:
Name: example.com
Address: 93.184.215.14
Name: example.com
Address: 2606:2800:21f:cb07:6820:80da:af6b:8b2c

A resposta DNS veio de 127.0.0.53, que é o endereço de loopback da máquina local. Isso significa que a resolução DNS está sendo feita pelo serviço de DNS local, que provavelmente é o systemd-resolved.
