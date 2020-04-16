docker run -d --name=co1 --net=host -p 5702:5702 -p 8090:8090 -p 5060-5090:5060-5090/udp \
-e CATS_PUBLIC_IP=10.31.205.9 \
-e CATS_HAZELCAST_PORT=5701 \
-e CATS_WEB_PORT=8090 \
-e CATS_HOME_URI=ftp://cats-home:cats-home@10.31.205.9:1000/cats-home.zip \
-e FRQ_LOG_ROOT=/var/log/frequentis \
artidocker.frequentis.frq/cats/cats-caseofficer-image:6.3.0
