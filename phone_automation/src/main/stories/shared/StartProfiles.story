Narrative:
As a user
I want to perform an action
So that I can achieve a business goal

Meta:

Scenario: installing
When installing profiles:
| hostIp     | profile       |
| <<CO1_IP>> | voip/grs      |
| <<CO1_IP>> | voip/opv      |
| <<CO1_IP>> | websocket/hmi |

Scenario: verify and start missing profiles
Given running profiles:
| hostIp     | profile       | timeout         | nr |
| <<CO1_IP>> | voip/grs      | <<Timeout|300>> | 1  |
| <<CO1_IP>> | voip/opv      | <<Timeout|300>> | 1  |
| <<CO1_IP>> | websocket/hmi | <<Timeout|300>> | 1  |
