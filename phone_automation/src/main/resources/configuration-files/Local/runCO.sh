docker run -d --name=co1 --net=host -p 5701:5701 -p 8090:8090 -e CATS_PUBLIC_IP=192.168.100.13 -e CATS_HAZELCAST_PORT=5701 -e CATS_WEB_PORT=8090 -e CATS_HOME_URI=ftp://cats-home:cats-home@192.168.100.10:1000/cats-home.zip   artidocker.frequentis.frq/cats/cats-caseofficer-image:4.2.0