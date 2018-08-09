#!/bin/bash

docker rm -f audio-app
docker run \
--name audio-app \
-v /var/log/frequentis:/var/log/frequentis \
-v /root/audiocfg:/opt/frequentis/etc/ \
--device=/dev/snd:/dev/snd \
--net=host \
-d --dns=172.17.42.1 \
-e NET_DATA=${audio_app_network_ip} \
-e NET_AUDIO=${audio_app_network_ip} \
--restart unless-stopped \
artidocker.frequentis.frq/fcsc-audio/xvp-audio-service:0.2.1-SNAPSHOT
