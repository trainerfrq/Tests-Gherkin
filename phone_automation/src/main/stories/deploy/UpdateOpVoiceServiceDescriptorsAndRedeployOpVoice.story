Scenario: Connect to deploymentServer
Given SSH connections:
| name             | remote-address       | remotePort | username | password  |
| deploymentServer | <<DEP_SERVER_IP>>    | 22         | root     | !frqAdmin |
| dockerHost1      | <<OPVOICE_HOST1_IP>> | 22         | root     | !frqAdmin |
| dockerHost2      | <<OPVOICE_HOST2_IP>> | 22         | root     | !frqAdmin |

Scenario: Update POSITIONS_WITHOUT_AUDIOBOX to contain only 2 positions
When SSH host deploymentServer executes sed -i '60s/.*/    "POSITIONS_WITHOUT_AUDIOBOX" : "${OP_VOICE_PARTITION_KEY_2},${OP_VOICE_PARTITION_KEY_3}"/' /var/opt/frequentis/xvp/orchestration-agent/daemon/data/descriptors/*${OP_VOICE_PARTITION_KEY_1}.json
When SSH host deploymentServer executes sed -i '60s/.*/    "POSITIONS_WITHOUT_AUDIOBOX" : "${OP_VOICE_PARTITION_KEY_2},${OP_VOICE_PARTITION_KEY_3}"/' /var/opt/frequentis/xvp/orchestration-agent/daemon/data/descriptors/*${OP_VOICE_PARTITION_KEY_2}.json
When SSH host deploymentServer executes sed -i '60s/.*/    "POSITIONS_WITHOUT_AUDIOBOX" : "${OP_VOICE_PARTITION_KEY_2},${OP_VOICE_PARTITION_KEY_3}"/' /var/opt/frequentis/xvp/orchestration-agent/daemon/data/descriptors/*${OP_VOICE_PARTITION_KEY_3}.json

Scenario: Publish the service descriptors and redeploy op-voice-service
Then SSH host deploymentServer executes /usr/bin/xvp services remove op-voice-service -g
Then SSH host deploymentServer executes /usr/bin/xvp descriptors download -g
Then SSH host deploymentServer executes /usr/bin/xvp services deploy --all -g
And waiting for 120 seconds

Scenario: Verify Op Voice Services are running
When SSH host dockerHost1 executes docker inspect -f '{{.State.Status}}' op-voice-service-${OP_VOICE_PARTITION_KEY_1}-1 and the output contains running
When SSH host dockerHost1 executes docker inspect -f '{{.State.Status}}' op-voice-service-${OP_VOICE_PARTITION_KEY_2}-1 and the output contains running
When SSH host dockerHost1 executes docker inspect -f '{{.State.Status}}' op-voice-service-${OP_VOICE_PARTITION_KEY_3}-1 and the output contains running
When SSH host dockerHost2 executes docker inspect -f '{{.State.Status}}' op-voice-service-${OP_VOICE_PARTITION_KEY_1}-2 and the output contains running
When SSH host dockerHost2 executes docker inspect -f '{{.State.Status}}' op-voice-service-${OP_VOICE_PARTITION_KEY_2}-2 and the output contains running
When SSH host dockerHost2 executes docker inspect -f '{{.State.Status}}' op-voice-service-${OP_VOICE_PARTITION_KEY_3}-2 and the output contains running
