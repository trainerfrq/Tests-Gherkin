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

Scenario: Stop all running voice-hmi services
When SSH host hmiHost1 executes docker rm -f $(docker ps -q -a -f name=${PARTITION_KEY_1})
And waiting for 5 seconds
When SSH host hmiHost2 executes docker rm -f $(docker ps -q -a -f name=${PARTITION_KEY_2})
And waiting for 5 seconds
When SSH host hmiHost3 executes docker rm -f $(docker ps -q -a -f name=${PARTITION_KEY_3})
And waiting for 5 seconds

Scenario: Start provision agent on host 1
!-- Remove exited container that could be previous provision agent containers
When SSH host hmiHost1 executes docker rm $(docker ps -q -a -f status=exited)
And the start provisioning agent script is copied to hmiHost1
And SSH host hmiHost1 executes chmod +x runPA.sh
And SSH host hmiHost1 executes ./runPA.sh
Then waiting for 30 seconds

Scenario: Prepare CATS configuration on host 1
!-- Remove line containing ${CATS_PUBLIC_IP} from cats-hazelcast-cluster-config.xml
!-- When SSH host hmiHost1 executes sed -i '/'CATS_PUBLIC_IP'/d' /var/lib/docker/volumes/sharedVolume/_data/cats/.frequentis-cats/cats-hazelcast-cluster-config.xml
!-- Add CATS_PUBLIC_IP and CATS_HAZELCAST_PORT environment variables to start.sh script (workaround for ICATS-2611)
!-- And SSH host hmiHost1 executes sed -i 's/javafx;hmi/javafx\/hmi -DCATS_PUBLIC_IP=${CATS_MASTER_IP} -DCATS_HAZELCAST_PORT=5701/' /var/lib/docker/volumes/sharedVolume/_data/cats/start.sh

Scenario: Start provision agent on host 2
!-- Remove exited container that could be previous provision agent containers
When SSH host hmiHost2 executes docker rm $(docker ps -q -a -f status=exited)
And the start provisioning agent script is copied to hmiHost2
And SSH host hmiHost2 executes chmod +x runPA.sh
And SSH host hmiHost2 executes ./runPA.sh
Then waiting for 30 seconds

Scenario: Prepare CATS configuration on host 2
!-- Remove line containing ${CATS_PUBLIC_IP} from cats-hazelcast-cluster-config.xml
!-- When SSH host hmiHost2 executes sed -i '/'CATS_PUBLIC_IP'/d' /var/lib/docker/volumes/sharedVolume/_data/cats/.frequentis-cats/cats-hazelcast-cluster-config.xml
!-- Add CATS_PUBLIC_IP and CATS_HAZELCAST_PORT environment variables to start.sh script (workaround for ICATS-2611)
!-- And SSH host hmiHost2 executes sed -i 's/javafx;hmi/javafx\/hmi -DCATS_PUBLIC_IP=${CATS_MASTER_IP} -DCATS_HAZELCAST_PORT=5701/' /var/lib/docker/volumes/sharedVolume/_data/cats/start.sh

Scenario: Start provision agent on host 3
!-- Remove exited container that could be previous provision agent containers
When SSH host hmiHost3 executes docker rm $(docker ps -q -a -f status=exited)
And the start provisioning agent script is copied to hmiHost3
And SSH host hmiHost3 executes chmod +x runPA.sh
And SSH host hmiHost3 executes ./runPA.sh
Then waiting for 30 seconds

Scenario: Prepare CATS configuration on host 3
!-- Remove line containing ${CATS_PUBLIC_IP} from cats-hazelcast-cluster-config.xml
!-- When SSH host hmiHost3 executes sed -i '/'CATS_PUBLIC_IP'/d' /var/lib/docker/volumes/sharedVolume/_data/cats/.frequentis-cats/cats-hazelcast-cluster-config.xml
!-- Add CATS_PUBLIC_IP and CATS_HAZELCAST_PORT environment variables to start.sh script (workaround for ICATS-2611)
!-- And SSH host hmiHost3 executes sed -i 's/javafx;hmi/javafx\/hmi -DCATS_PUBLIC_IP=${CATS_MASTER_IP} -DCATS_HAZELCAST_PORT=5701/' /var/lib/docker/volumes/sharedVolume/_data/cats/start.sh

Scenario: Download image descriptor
Then downloading docker image from <<voiceHmiDockerImageArtifactoryUri>> to path /configuration-files/<<systemName>>/voice-hmi-service-docker-image.json

Scenario: Upload image descriptor
When deleting all previous versions of image descriptors for service xvp-voice/voice-hmi-service on endpoint <<configurationMngEndpoint>>
When issuing http POST request to endpoint <<configurationMngEndpoint>> and path configurations/orchestration/groups/images/ with payload /configuration-files/<<systemName>>/voice-hmi-service-docker-image.json

Scenario: Change layout to new voice-hmi version
Then adding to layout voice on endpoint <<configurationMngEndpoint>> the following service widgets:
| Fully_Qualified_Service_Name | Service_Version      | Position_X | Position_Y | Size_Width | Size_Height |
| xvp-voice/voice-hmi-service  | ${voice.hmi.version} | 1          | 0          | 7          | 6           |

Scenario: Commit and activate configuration
When using endpoint <<configurationMngEndpoint>> commit and activate the configuration in path configurations/activate
!-- TODO Uncomment steps when CATS is upgraded to 5.4 version
!-- When using endpoint <<configurationMngEndpoint>> commit the configuration and name commit commitId
!-- Then waiting for 1 seconds
!-- When activating commit commitId to endpoint <<configurationMngEndpoint>> and path configurations/activate
Then waiting for 3 seconds

Scenario: Update voice hmi service instances
When the update voice hmi script is copied to deploymentServer
And SSH host deploymentServer executes chmod +x hmiUpdate.sh
And SSH host deploymentServer executes ./hmiUpdate.sh
And waiting for 60 seconds

Scenario: Verify services are running on dockerhost1
When SSH host hmiHost1 executes  docker inspect -f '{{.State.Status}}' $(docker ps -q -f name=${PARTITION_KEY_1}) and the output contains running

Scenario: Verify services are running on dockerhost2
When SSH host hmiHost2 executes  docker inspect -f '{{.State.Status}}' $(docker ps -q -f name=${PARTITION_KEY_2}) and the output contains running

Scenario: Verify services are running on dockerhost3
When SSH host hmiHost3 executes  docker inspect -f '{{.State.Status}}' $(docker ps -q -f name=${PARTITION_KEY_3}) and the output contains running
