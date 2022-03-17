#!/bin/bash
#Удаляем старое
docker rm -f tor
docker rmi -f mytor
#Билдим
docker build -t mytor .
#Стартуем
docker run -it -p 3128:3128 -p 3129:3129 -p 5353:5353 -p 9040:9040 -p 9050:9050 --restart unless-stopped --privileged --dns=127.0.0.1 --name tor -d mytor