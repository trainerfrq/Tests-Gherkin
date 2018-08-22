Scenario: Connect to deploymentServer
Given SSH connections:
| name             | remote-address      | remotePort | username | password  |
| deploymentServer | <<DEP_SERVER_IP>>   | 22         | root     | !frqAdmin |
| dockerHost1      | <<DOCKER_HOST1_IP>> | 22         | root     | !frqAdmin |
| dockerHost2      | <<DOCKER_HOST2_IP>> | 22         | root     | !frqAdmin |
| dockerHost3      | <<DOCKER_HOST3_IP>> | 22         | root     | !frqAdmin |

Scenario: Stop running Op Voice Services
When SSH host deploymentServer executes /usr/bin/xvp services remove op-voice-service -g
Then waiting for 5 seconds

Scenario: Download docker image from artifactory
Then downloading op-voice-service docker image version ${op.voice.version} from <<opVoiceDockerImageArtifactoryUri>> to path /configuration-files/<<systemName>>/op-voice-service-docker-image.json

Scenario: Upload docker image
When issuing http POST request to endpoint <<configurationMngEndpoint>> and path configurations/orchestration/groups/images/ with payload /configuration-files/<<systemName>>/op-voice-service-docker-image.json

Scenario: Change version of Op Voice Service in deployed service descriptors
!-- Update the deployed service descriptor with op-voice-service version for partition 1
When SSH host deploymentServer executes sed -i '4s/.*/  "tag" : "${op.voice.version}",/' /var/opt/frequentis/xvp/orchestration-agent/agent/descriptors/*${OP_VOICE_PARTITION_KEY_1}.json
!-- Update the deployed service descriptor with op-voice-service version for partition 2
When SSH host deploymentServer executes sed -i '4s/.*/  "tag" : "${op.voice.version}",/' /var/opt/frequentis/xvp/orchestration-agent/agent/descriptors/*${OP_VOICE_PARTITION_KEY_2}.json
!-- Update the deployed service descriptor with op-voice-service version for partition 3
When SSH host deploymentServer executes sed -i '4s/.*/  "tag" : "${op.voice.version}",/' /var/opt/frequentis/xvp/orchestration-agent/agent/descriptors/*${OP_VOICE_PARTITION_KEY_3}.json

Scenario: Publish the service descriptors and start services
Then SSH host deploymentServer executes /usr/bin/xvp descriptors publish -g
Then SSH host deploymentServer executes /usr/bin/xvp services deploy --all -g
And waiting for 30 seconds

Scenario: Set restart policy for Op Voice Services
!-- Scenario is needed to de-active the default on-failure restart policy,
!-- otherwise the next scenario will always pass, as containers will be always running
Then SSH host dockerHost3 executes docker update --restart=no op-voice-service-${OP_VOICE_PARTITION_KEY_1}
Then SSH host dockerHost3 executes docker update --restart=no op-voice-service-${OP_VOICE_PARTITION_KEY_2}
Then SSH host dockerHost3 executes docker update --restart=no op-voice-service-${OP_VOICE_PARTITION_KEY_3}
Then waiting for 30 seconds

Scenario: Verify Op Voice Services are running
When SSH host dockerHost3 executes docker inspect -f '{{.State.Status}}' op-voice-service-${OP_VOICE_PARTITION_KEY_1} and the output contains running
When SSH host dockerHost3 executes docker inspect -f '{{.State.Status}}' op-voice-service-${OP_VOICE_PARTITION_KEY_2} and the output contains running
When SSH host dockerHost3 executes docker inspect -f '{{.State.Status}}' op-voice-service-${OP_VOICE_PARTITION_KEY_3} and the output contains running
