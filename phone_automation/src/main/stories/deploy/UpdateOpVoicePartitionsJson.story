Scenario: Connect to deploymentServer
Given SSH connections:
| name             | remote-address       | remotePort | username | password  |
| catsMaster       | <<CATS_MASTER_IP>>   | 22         | root     | !frqAdmin |
| deploymentServer | <<DEP_SERVER_IP>>    | 22         | root     | !frqAdmin |
| dockerHost1      | <<OPVOICE_HOST1_IP>> | 22         | root     | !frqAdmin |
| dockerHost2      | <<OPVOICE_HOST2_IP>> | 22         | root     | !frqAdmin |

Scenario: Upload updated configuration file in Configuration Management Service for Op Voice Service
When using endpoint <<configurationMngEndpoint>> create configuration id op-voice-service
Then waiting for 3 seconds
And issuing http PUT request to endpoint <<configurationMngEndpoint>> and path configurations/op-voice-service/generic/items/partitions.json with payload /configuration-files/<<systemName>>/partitionsUpdated.json

Scenario: Commit and activate configuration
When using endpoint <<configurationMngEndpoint>> commit the configuration and name commit commitId
Then waiting for 1 seconds
When activating commit commitId to endpoint <<configurationMngEndpoint>> and path configurations/activate
Then waiting for 3 seconds

Scenario: Publish the service descriptors and redeploy op-voice-service
Then SSH host deploymentServer executes /usr/bin/xvp services remove op-voice-service -g
Then SSH host deploymentServer executes /usr/bin/xvp services deploy --all -g
And waiting for 120 seconds

Scenario: Verify Op Voice Services are running
When SSH host dockerHost1 executes docker inspect -f '{{.State.Status}}' op-voice-service-${OP_VOICE_PARTITION_KEY_1}-1 and the output contains running
When SSH host dockerHost1 executes docker inspect -f '{{.State.Status}}' op-voice-service-${OP_VOICE_PARTITION_KEY_2}-1 and the output contains running
When SSH host dockerHost1 executes docker inspect -f '{{.State.Status}}' op-voice-service-${OP_VOICE_PARTITION_KEY_3}-1 and the output contains running
When SSH host dockerHost2 executes docker inspect -f '{{.State.Status}}' op-voice-service-${OP_VOICE_PARTITION_KEY_1}-2 and the output contains running
When SSH host dockerHost2 executes docker inspect -f '{{.State.Status}}' op-voice-service-${OP_VOICE_PARTITION_KEY_2}-2 and the output contains running
When SSH host dockerHost2 executes docker inspect -f '{{.State.Status}}' op-voice-service-${OP_VOICE_PARTITION_KEY_3}-2 and the output contains running

