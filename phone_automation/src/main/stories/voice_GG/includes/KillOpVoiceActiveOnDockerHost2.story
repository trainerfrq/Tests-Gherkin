Scenario: Connect to deploymentServer
Given SSH connections:
| name             | remote-address       | remotePort | username | password  |
| dockerHost2      | <<OPVOICE_HOST2_IP>> | 22         | root     | !frqAdmin |

Scenario: Stop Op Voice Services on docker host 2
When SSH host dockerHost2 executes docker kill op-voice-service-${OP_VOICE_PARTITION_KEY_1}-2
When SSH host dockerHost2 executes docker kill op-voice-service-${OP_VOICE_PARTITION_KEY_2}-2
When SSH host dockerHost2 executes docker kill op-voice-service-${OP_VOICE_PARTITION_KEY_3}-2



