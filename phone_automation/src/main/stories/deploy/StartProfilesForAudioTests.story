Scenario: Install websocket audio simulator profile
When installing profiles:
| hostIp     | profile                        |
| <<CO3_IP>> | websocket/audio_<<systemName>> |

Scenario: Start profile
Given running profiles:
| hostIp     | profile                        | timeout        | nr |
| <<CO3_IP>> | websocket/audio_<<systemName>> | <<Timeout|60>> | 1  |
Then waiting for 10 seconds

Scenario: Verify profile
When verify profiles:
| hostIp     | profile                        | nr |
| <<CO3_IP>> | websocket/audio_<<systemName>> | 1  |
