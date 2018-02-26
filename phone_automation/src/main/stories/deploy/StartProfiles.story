Scenario: Install profiles
When installing profiles:
| hostIp     | profile             |
| <<CO1_IP>> | voip/<<systemName>> |
| <<CO1_IP>> | websocket/hmi       |

Scenario: Start profiles
Given running profiles:
| hostIp     | profile             | timeout        | nr |
| <<CO1_IP>> | voip/<<systemName>> | <<Timeout|60>> | 1  |
| <<CO1_IP>> | websocket/hmi       | <<Timeout|60>> | 1  |
Then waiting for 10 seconds
