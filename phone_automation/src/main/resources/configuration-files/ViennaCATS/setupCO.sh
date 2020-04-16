CATS_HOME=/opt/cats-case-officer
PROJECT_VERSION=1.1.1-1.2.1
docker cp master:/cats/phone_automation-$PROJECT_VERSION/.frequentis-cats $CATS_HOME
rm -rf $CATS_HOME/.frequentis-cats/master
rm -rf $CATS_HOME/.frequentis-cats/cats-accounts.properties
rm -rf $CATS_HOME/.frequentis-cats/cats-recent-projects.properties
sed -i 's/${CATS_PUBLIC_IP}/10.16.156.19/' $CATS_HOME/.frequentis-cats/cats-hazelcast-client-config.xml
sed -i 's/${CATS_HAZELCAST_PORT}/5701/' $CATS_HOME/.frequentis-cats/cats-hazelcast-cluster-config.xml
sed -i '8d' $CATS_HOME/.frequentis-cats/cats-hazelcast-cluster-config.xml

