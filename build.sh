#!/bin/bash
#Удаляем старое
docker rm -f tor
docker rmi -f mytor
#Билдим
docker build -t mytor .
#Стартуем
docker run -it -p 9050:9050 --restart unless-stopped --privileged --dns=127.0.0.1 --name tor -d mytor