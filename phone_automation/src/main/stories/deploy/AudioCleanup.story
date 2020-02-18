Scenario: Connect to hosts
Given SSH connections:
| name     | remote-address | remotePort | username | password  |
| hmiHost1 | <<CLIENT1_IP>> | 22         | root     | !frqAdmin |
| hmiHost2 | <<CLIENT2_IP>> | 22         | root     | !frqAdmin |
| hmiHost3 | <<CLIENT3_IP>> | 22         | root     | !frqAdmin |
| coHost   | <<CO3_IP>>     | 22         | root     | !frqAdmin |

Scenario: Stop all running voice-hmi services
When SSH host hmiHost1 executes docker rm -f $(docker ps -f name=${PARTITION_KEY_1})
And waiting for 5 seconds
When SSH host hmiHost2 executes docker rm -f $(docker ps -f name=${PARTITION_KEY_2})
And waiting for 5 seconds
When SSH host hmiHost3 executes docker rm -f $(docker ps -f name=${PARTITION_KEY_3})
And waiting for 5 seconds

Scenario: Stop profiles
When stopping profiles:
| hostIp     | profile                        | timeout        | nr |
| <<CO3_IP>> | websocket/hmi                  | <<Timeout|60>> | 1  |
| <<CO3_IP>> | websocket/audio_<<systemName>> | <<Timeout|60>> | 1  |
Then waiting for 5 seconds

Scenario: Stop case officer
When SSH host coHost executes docker rm -f co1
Then waiting for 5 seconds
