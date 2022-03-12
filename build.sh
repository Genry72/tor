#!/bin/bash
#Удаляем старое
docker rm -f tor
docker rmi -f mytor
#Билдим
docker build -t mytor .
#Стартуем
docker run -it -p 8118:8118 -p 9050:9050 --name tor -d mytor