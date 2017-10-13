Meta:

Narrative:
As a user
I want to perform an action
So that I can achieve a business goal

Scenario: scenario description
When stopping profiles:
| hostIp     | profile  | timeout         | nr |
| <<CO1_IP>> | voip/opv | <<Timeout|300>> | 1  |
| <<CO1_IP>> | voip/grs | <<Timeout|300>> | 1  |
Then waiting for 10 seconds
When SSH host sess1 executes docker rm -f co1
