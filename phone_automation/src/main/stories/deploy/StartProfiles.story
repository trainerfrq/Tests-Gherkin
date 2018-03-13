Scenario: Install profiles
When installing profiles:
| hostIp     | profile             |
| <<CO3_IP>> | voip/<<systemName>> |
| <<CO3_IP>> | websocket/hmi       |

Scenario: Start profiles
Given running profiles:
| hostIp     | profile             | timeout        | nr |
| <<CO3_IP>> | voip/<<systemName>> | <<Timeout|60>> | 1  |
| <<CO3_IP>> | websocket/hmi       | <<Timeout|60>> | 1  |
Then waiting for 10 seconds
