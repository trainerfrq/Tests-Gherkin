Scenario: Connect to host
Given SSH connections:
| name     | remote-address | remotePort | username | password  |
| coHost   | <<CO3_IP>>     | 22         | root     | !frqAdmin |

Scenario: Stop profiles
When stopping profiles:
| hostIp     | profile             | timeout        | nr |
| <<CO3_IP>> | voip/<<systemName>> | <<Timeout|60>> | 1  |
| <<CO3_IP>> | websocket/hmi       | <<Timeout|60>> | 1  |
Then waiting for 5 seconds

Scenario: Stop case officer
When SSH host coHost executes docker rm -f co1
Then waiting for 5 seconds
