#!/usr/bin/env bash
docker cp master:/cats/.frequentis-cats /opt/cats-case-officer
docker cp master:/cats/dsl /opt/cats-case-officer
rm -rf /opt/cats-case-officer/.frequentis-cats/master
rm -rf /opt/cats-case-officer/.frequentis-cats/cats-accounts.properties
rm -rf /opt/cats-case-officer/.frequentis-cats/cats-recent-projects.properties
sed -i 's/${CATS_PUBLIC_IP}/10.31.205.100/' cats-hazelcast-client-config.xml
sed -i 's/${CATS_HAZELCAST_PORT}/5701/' cats-hazelcast-cluster-config.xml
sed -i '8d' cats-hazelcast-cluster-config.xml

