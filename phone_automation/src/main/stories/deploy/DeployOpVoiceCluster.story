Scenario: Connect to deploymentServer
Given SSH connections:
| name             | remote-address       | remotePort | username | password  |
| deploymentServer | <<DEP_SERVER_IP>>    | 22         | root     | !frqAdmin |
| dockerHost1      | <<OPVOICE_HOST1_IP>> | 22         | root     | !frqAdmin |
| dockerHost2      | <<OPVOICE_HOST2_IP>> | 22         | root     | !frqAdmin |
| hmiHost1         | <<CLIENT1_IP>>       | 22         | root     | !frqAdmin |
| hmiHost2         | <<CLIENT2_IP>>       | 22         | root     | !frqAdmin |
| hmiHost3         | <<CLIENT3_IP>>       | 22         | root     | !frqAdmin |
| catsMaster       | <<CATS_MASTER_IP>>   | 22         | root     | !frqAdmin |

Scenario: Stop all running voice-hmi services
When SSH host hmiHost1 executes docker rm -f $(docker ps -q -a -f name=${PARTITION_KEY_1})
And waiting for 5 seconds
When SSH host hmiHost2 executes docker rm -f $(docker ps -q -a -f name=${PARTITION_KEY_2})
And waiting for 5 seconds
When SSH host hmiHost3 executes docker rm -f $(docker ps -q -a -f name=${PARTITION_KEY_3})
And waiting for 5 seconds

Scenario: Stop running Op Voice Services
When SSH host deploymentServer executes /usr/bin/xvp services remove op-voice-service -g
Then waiting for 5 seconds

Scenario: Download docker image from artifactory and change it for cluster mode
Then downloading docker image from <<opVoiceDockerImageArtifactoryUri>> to path /configuration-files/<<systemName>>/op-voice-service-docker-image.json

Scenario: Upload docker image
When issuing http POST request to endpoint <<configurationMngEndpoint>> and path configurations/orchestration/groups/images/ with payload /configuration-files/<<systemName>>/op-voice-service-docker-image.json

Scenario: Change version of Op Voice Service in deployed service descriptors
!-- Update the deployed service descriptor with op-voice-service version for partition 1
When SSH host deploymentServer executes sed -i '4s/.*/  "tag" : "${op.voice.version}",/' /var/opt/frequentis/xvp/orchestration-agent/daemon/data/descriptors/*${OP_VOICE_PARTITION_KEY_1}.json
!-- Update the deployed service descriptor with op-voice-service version for partition 2
When SSH host deploymentServer executes sed -i '4s/.*/  "tag" : "${op.voice.version}",/' /var/opt/frequentis/xvp/orchestration-agent/daemon/data/descriptors/*${OP_VOICE_PARTITION_KEY_2}.json
!-- Update the deployed service descriptor with op-voice-service version for partition 3
When SSH host deploymentServer executes sed -i '4s/.*/  "tag" : "${op.voice.version}",/' /var/opt/frequentis/xvp/orchestration-agent/daemon/data/descriptors/*${OP_VOICE_PARTITION_KEY_3}.json

Scenario: Publish the service descriptors and start services
Then SSH host deploymentServer executes /usr/bin/xvp descriptors download -g
Then SSH host deploymentServer executes /usr/bin/xvp services deploy op-voice-service -g
And waiting for 180 seconds

Scenario: Verify Op Voice Services are running
When SSH host dockerHost1 executes docker inspect -f '{{.State.Status}}' op-voice-service-${OP_VOICE_PARTITION_KEY_1}-1 and the output contains running
When SSH host dockerHost1 executes docker inspect -f '{{.State.Status}}' op-voice-service-${OP_VOICE_PARTITION_KEY_2}-1 and the output contains running
When SSH host dockerHost1 executes docker inspect -f '{{.State.Status}}' op-voice-service-${OP_VOICE_PARTITION_KEY_3}-1 and the output contains running
When SSH host dockerHost2 executes docker inspect -f '{{.State.Status}}' op-voice-service-${OP_VOICE_PARTITION_KEY_1}-2 and the output contains running
When SSH host dockerHost2 executes docker inspect -f '{{.State.Status}}' op-voice-service-${OP_VOICE_PARTITION_KEY_2}-2 and the output contains running
When SSH host dockerHost2 executes docker inspect -f '{{.State.Status}}' op-voice-service-${OP_VOICE_PARTITION_KEY_3}-2 and the output contains running
