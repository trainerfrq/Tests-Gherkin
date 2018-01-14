mvn clean verify -pl phone_automation -DskipTests -P AUTOMATION-PACKAGE -DskipTraceImport -DCATS_PUBLIC_IP=192.168.100.1 -DCATS_HAZELCAST_PORT=5701 -DCATS_CO_IP=192.168.100.1
