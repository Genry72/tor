#!/bin/bash
#Удаляем старое
docker rm -f my
docker rmi -f mymy
#Билдим
docker build -t mymy .
#Стартуем
docker run -it --cap-add=NET_ADMIN -p 9050:9050 --restart unless-stopped --dns=127.0.0.1 -p 1194:1194/udp -p 80:8080/tcp -e HOST_ADDR=$(curl -s https://api.ipify.org) --name my -d mymy