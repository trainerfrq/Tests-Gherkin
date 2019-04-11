Scenario: Connect to deploymentServer
Given SSH connections:
| name             | remote-address       | remotePort | username | password  |
| dockerHost1      | <<OPVOICE_HOST1_IP>> | 22         | root     | !frqAdmin |

Scenario: Start Op Voice Services on docker host 1
When SSH host dockerHost1 executes docker start op-voice-service-${OP_VOICE_PARTITION_KEY_1}-1
When SSH host dockerHost1 executes docker start op-voice-service-${OP_VOICE_PARTITION_KEY_2}-1
When SSH host dockerHost1 executes docker start op-voice-service-${OP_VOICE_PARTITION_KEY_3}-1

