Scenario: Install profiles
When installing profiles:
| hostIp     | profile         |
| <<CO3_IP>> | websocket/audio |
| <<CO3_IP>> | websocket/hmi   |

Scenario: Start profiles
When starting profiles:
| hostIp     | profile         | timeout        | nr |
| <<CO3_IP>> | websocket/audio | <<Timeout|60>> | 1  |
| <<CO3_IP>> | websocket/hmi   | <<Timeout|60>> | 1  |
Then waiting for 10 seconds

Scenario: Verify profiles
When verify profiles:
| hostIp     | profile         | nr |
| <<CO3_IP>> | websocket/audio | 1  |
| <<CO3_IP>> | websocket/hmi   | 1  |
