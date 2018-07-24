#!/bin/bash

docker rm -f audio-app
docker run \
--name audio-app \
-v /var/log/frequentis:/var/log/frequentis \
-v /root/audiocfg:/opt/frequentis/etc/ \
--device=/dev/snd:/dev/snd \
--net=host \
-d --dns=172.17.42.1 \
-e NET_DATA=192.168.10.14 \
-e NET_AUDIO=192.168.10.14 \
--restart unless-stopped \
internalregistry:5000/fcsc-audio/xvp-audio-service:0.2.0-working
