#!/bin/bash
#Удаляем старое
docker rm -f vpn
docker rmi -f myvpn
#Билдим
docker build -t myvpn .
#Стартуем
# docker run -it -p 9050:9050 --restart unless-stopped --privileged  --name vpn -d myvpn
docker run --cap-add=NET_ADMIN -p 1194:1194/udp -p 80:8080/tcp -e HOST_ADDR=localhost  --name vpn -d myvpn