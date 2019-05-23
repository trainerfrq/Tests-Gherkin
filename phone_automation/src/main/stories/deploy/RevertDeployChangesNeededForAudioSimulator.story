Scenario: Connect to deploymentServer
Given SSH connections:
| name             | remote-address     | remotePort | username | password  |
| catsMaster       | <<CATS_MASTER_IP>> | 22         | root     | !frqAdmin |
| deploymentServer | <<DEP_SERVER_IP>>  | 22         | root     | !frqAdmin |
| hmiHost1         | <<CLIENT1_IP>>     | 22         | root     | !frqAdmin |

Scenario: Upload updated configuration file in Configuration Management Service for Op Voice Service
When using endpoint <<configurationMngEndpoint>> create configuration id op-voice-service
Then waiting for 3 seconds
And issuing http PUT request to endpoint <<configurationMngEndpoint>> and path configurations/op-voice-service/generic/items/partitions.json with payload /configuration-files/<<systemName>>/partitions.json

Scenario: Commit and activate configuration
When using endpoint <<configurationMngEndpoint>> commit the configuration and name commit commitId
Then waiting for 1 seconds
When activating commit commitId to endpoint <<configurationMngEndpoint>> and path configurations/activate
Then waiting for 3 seconds

Scenario: Change environment variable POSITIONS_WITHOUT_AUDIOBOX in deployed service descriptors
When SSH host deploymentServer executes sed -i '57s/.*/  "POSITIONS_WITHOUT_AUDIOBOX" : "${OP_VOICE_PARTITION_KEY_1},${OP_VOICE_PARTITION_KEY_2},${OP_VOICE_PARTITION_KEY_3}",/' /var/opt/frequentis/xvp/orchestration-agent/daemon/data/descriptors/*${OP_VOICE_PARTITION_KEY_1}.json
When SSH host deploymentServer executes sed -i '57s/.*/  "POSITIONS_WITHOUT_AUDIOBOX" : "${OP_VOICE_PARTITION_KEY_1},${OP_VOICE_PARTITION_KEY_2},${OP_VOICE_PARTITION_KEY_3}",/' /var/opt/frequentis/xvp/orchestration-agent/daemon/data/descriptors/*${OP_VOICE_PARTITION_KEY_2}.json
When SSH host deploymentServer executes sed -i '57s/.*/  "POSITIONS_WITHOUT_AUDIOBOX" : "${OP_VOICE_PARTITION_KEY_1},${OP_VOICE_PARTITION_KEY_2},${OP_VOICE_PARTITION_KEY_3}",/' /var/opt/frequentis/xvp/orchestration-agent/daemon/data/descriptors/*${OP_VOICE_PARTITION_KEY_3}.json

Scenario: Publish the service descriptors and redeploy op-voice-service
Then SSH host deploymentServer executes /usr/bin/xvp services remove op-voice-service -g
Then SSH host deploymentServer executes /usr/bin/xvp descriptors download -g
Then SSH host deploymentServer executes /usr/bin/xvp services deploy --all -g
And waiting for 120 seconds

Scenario: Start audio-app on host 1
When SSH host hmiHost1 executes ./launchAudioApp.sh
