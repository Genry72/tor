#!/bin/bash
#Удаляем старое
docker rm -f tor
docker rmi -f mytor
#Билдим
docker build -t mytor .
#Стартуем
docker run -it -p 3128:3128 -p 3129:3129 -p 53530:53530 -p 9141:9141 --restart unless-stopped --name tor -d mytor