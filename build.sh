#!/bin/bash
#Удаляем старое
docker rm -f tor
docker rmi -f mytor
#Билдим
docker build -t mytor .
#Стартуем
docker run -it -p 9050:9050 -p 3128:8118 -p 53530:53530 -p 3129:3129 --restart unless-stopped --name tor -d mytor