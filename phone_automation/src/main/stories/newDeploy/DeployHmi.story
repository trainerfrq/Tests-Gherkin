Scenario: Connect to hosts
Given SSH connections:
| name             | remote-address      | remotePort | username | password  |
| deploymentServer | <<DEP_SERVER_IP>>   | 22         | root     | !frqAdmin |
| dockerHost1      | <<DOCKER_HOST1_IP>> | 22         | root     | !frqAdmin |
| dockerHost2      | <<DOCKER_HOST2_IP>> | 22         | root     | !frqAdmin |
| dockerHost3      | <<DOCKER_HOST3_IP>> | 22         | root     | !frqAdmin |
| hmiHost1         | <<CLIENT1_IP>>      | 22         | root     | !frqAdmin |
| hmiHost2         | <<CLIENT2_IP>>      | 22         | root     | !frqAdmin |
| hmiHost3         | <<CLIENT3_IP>>      | 22         | root     | !frqAdmin |

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

Scenario: Start provision agent on host 3
!-- Remove exited container that could be previous provision agent containers
When SSH host hmiHost3 executes docker rm $(docker ps -q -a -f status=exited)
And the start provisioning agent script is copied to hmiHost3
And SSH host hmiHost3 executes chmod +x runPA.sh
And SSH host hmiHost3 executes ./runPA.sh
Then waiting for 30 seconds

Scenario: Prepare CATS configuration on host 3
When the start agent script is copied to CATS folder of the hmiHost3
!-- Remove line containing ${CATS_PUBLIC_IP} from cats-hazelcast-cluster-config.xml
And SSH host hmiHost3 executes sed -i '/${CATS_PUBLIC_IP}/d' /var/lib/docker/volumes/sharedVolume/_data/cats/.frequentis-cats/cats-hazelcast-cluster-config.xml
!-- Replace ${CATS_HAZELCAST_PORT} with 5701 from cats-hazelcast-cluster-config.xml
And SSH host hmiHost3 executes sed -i 's/${CATS_HAZELCAST_PORT}/5701/g' /var/lib/docker/volumes/sharedVolume/_data/cats/.frequentis-cats/cats-hazelcast-cluster-config.xml
!-- Replace ${CATS_PUBLIC_IP} with the ip from cats-hazelcast-client-config.xml
And SSH host hmiHost3 executes sed -i 's/${CATS_PUBLIC_IP}/<<DEP_SERVER_IP>>/g' /var/lib/docker/volumes/sharedVolume/_data/cats/.frequentis-cats/cats-hazelcast-client-config.xml

Scenario: Download image descriptor
Then downloading voice-hmi-service docker image version ${voice.hmi.version} from <<voiceHmiDockerImageArtifactoryUri>> to path /configuration-files/<<systemName>>/voice-hmi-service-docker-image.json

Scenario: Upload image descriptor
When issuing http POST request to endpoint <<configurationMngEndpoint>> and path /configurations/orchestration/groups/images/ with payload /configuration-files/<<systemName>>/voice-hmi-service-docker-image.json

Scenario: Change layout to new voice-hmi version
Then adding to layout voice on endpoint <<configurationMngEndpoint>> the following service widgets:
| Fully_Qualified_Service_Name | Service_Version      | Position_X | Position_Y | Size_Width | Size_Height |
| xvp-voice/voice-hmi-service  | ${voice.hmi.version} | 1          | 0          | 7          | 6           |

Scenario: Commit and activate configuration
When using endpoint <<configurationMngEndpoint>> commit the configuration and name version versionId
Then waiting for 1 seconds
When activating version versionId to endpoint <<configurationMngEndpoint>> and path configurations/activate
Then waiting for 3 seconds

Scenario: Update voice hmi service instances
When the update voice hmi script is copied to deploymentServer
And SSH host deploymentServer executes chmod +x hmi-update.sh
And SSH host deploymentServer executes ./hmi-update.sh
And waiting for 60 seconds

Scenario: Verify services are running on dockerhost1
When SSH host hmiHost1 executes docker inspect -f '{{.State.Status}}' voice-hmi03 and the output contains running

Scenario: Verify services are running on dockerhost2
When SSH host hmiHost2 executes docker inspect -f '{{.State.Status}}' voice-hmi04 and the output contains running

Scenario: Verify services are running on dockerhost3
When SSH host hmiHost3 executes docker inspect -f '{{.State.Status}}' voice-hmi05 and the output contains running
