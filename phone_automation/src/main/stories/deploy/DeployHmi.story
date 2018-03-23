Scenario: Connect to hosts
Given SSH connections:
| name             | remote-address    | remotePort | username | password  |
| deploymentServer | <<DEP_SERVER_IP>> | 22         | root     | !frqAdmin |
| hmiHost1         | <<CO1_IP>>        | 22         | root     | !frqAdmin |
| hmiHost2         | <<CO2_IP>>        | 22         | root     | !frqAdmin |

Scenario: Stop HMIs
When SSH host deploymentServer executes /opt/frequentis/xvp-deployment/scripts/xvp remove voice_hmi03
And SSH host deploymentServer executes /opt/frequentis/xvp-deployment/scripts/xvp remove voice_hmi04

Scenario: Start provision agent on host 1
!-- Remove exited container that could be previous provision agent containers
When SSH host hmiHost1 executes docker rm $(docker ps -q -a -f status=exited)
And the start provisioning agent script is copied to hmiHost1
And SSH host hmiHost1 executes chmod +x runPA.sh
And SSH host hmiHost1 executes ./runPA.sh
Then waiting for 30 seconds

Scenario: Prepare CATS configuration on host 1
When the start agent script is copied to CATS folder of the hmiHost1
!-- Remove line containing ${CATS_PUBLIC_IP} from cats-hazelcast-cluster-config.xml
And SSH host hmiHost1 executes sed -i '/${CATS_PUBLIC_IP}/d' /var/lib/docker/volumes/sharedVolume/_data/cats/.frequentis-cats/cats-hazelcast-cluster-config.xml
!-- Replace ${CATS_HAZELCAST_PORT} with 5701 from cats-hazelcast-cluster-config.xml
And SSH host hmiHost1 executes sed -i 's/${CATS_HAZELCAST_PORT}/5701/g' /var/lib/docker/volumes/sharedVolume/_data/cats/.frequentis-cats/cats-hazelcast-cluster-config.xml
!-- Replace ${CATS_PUBLIC_IP} with the ip of cats master from cats-hazelcast-client-config.xml
And SSH host hmiHost1 executes sed -i 's/${CATS_PUBLIC_IP}/<<DEP_SERVER_IP>>/g' /var/lib/docker/volumes/sharedVolume/_data/cats/.frequentis-cats/cats-hazelcast-client-config.xml

Scenario: Start provision agent on host 2
!-- Remove exited container that could be previous provision agent containers
When SSH host hmiHost2 executes docker rm $(docker ps -q -a -f status=exited)
And the start provisioning agent script is copied to hmiHost2
And SSH host hmiHost2 executes chmod +x runPA.sh
And SSH host hmiHost2 executes ./runPA.sh
Then waiting for 30 seconds

Scenario: Prepare CATS configuration on host 2
When the start agent script is copied to CATS folder of the hmiHost2
!-- Remove line containing ${CATS_PUBLIC_IP} from cats-hazelcast-cluster-config.xml
And SSH host hmiHost2 executes sed -i '/${CATS_PUBLIC_IP}/d' /var/lib/docker/volumes/sharedVolume/_data/cats/.frequentis-cats/cats-hazelcast-cluster-config.xml
!-- Replace ${CATS_HAZELCAST_PORT} with 5701 from cats-hazelcast-cluster-config.xml
And SSH host hmiHost2 executes sed -i 's/${CATS_HAZELCAST_PORT}/5701/g' /var/lib/docker/volumes/sharedVolume/_data/cats/.frequentis-cats/cats-hazelcast-cluster-config.xml
!-- Replace ${CATS_PUBLIC_IP} with the ip from cats-hazelcast-client-config.xml
And SSH host hmiHost2 executes sed -i 's/${CATS_PUBLIC_IP}/<<DEP_SERVER_IP>>/g' /var/lib/docker/volumes/sharedVolume/_data/cats/.frequentis-cats/cats-hazelcast-client-config.xml

Scenario: Start HMIs
When SSH host deploymentServer executes /opt/frequentis/xvp-deployment/scripts/xvp deploy voice_hmi03
And SSH host deploymentServer executes /opt/frequentis/xvp-deployment/scripts/xvp deploy voice_hmi04
Then waiting for 120 seconds
