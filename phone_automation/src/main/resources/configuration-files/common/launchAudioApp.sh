#!/bin/bash

docker rm -f audio-app
docker run --name audio-app -v /var/log/frequentis:/var/log/frequentis \
-v /root/audiocfg:/opt/frequentis/etc/ \
--device=/dev/snd:/dev/snd \
--net=host \
-d --dns=10.255.255.1 \
-l 8805/tcp.net=data0 \
-l 3000-3999/udp.net=audioA,audioB \
-e NET_DATA=${audio_app_macvlandata_ip} \
-e NET_AUDIO=${audio_app_macvlanaudio_ip} \
--restart unless-stopped \
artidocker.frequentis.frq/fcsc-audio/xvp-audio-service:0.12.0-SNAPSHOT
