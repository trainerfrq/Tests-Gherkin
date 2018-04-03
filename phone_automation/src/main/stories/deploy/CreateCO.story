Scenario: Connect to case officer host
Given SSH connections:
| name   | remote-address | remotePort | username | password  |
| coHost | <<CO3_IP>>     | 22         | root     | !frqAdmin |

Scenario: Stop case officer
When SSH host coHost executes docker rm -f co1
Then waiting for 5 seconds

Scenario: Create case officer script
When the start case officer script is copied to coHost
And SSH host coHost executes chmod +x runCO.sh

Scenario: Start case officer
When SSH host coHost executes ./runCO.sh
Then waiting for 60 seconds

Scenario: Verify case officer is running
When SSH host coHost executes docker inspect -f '{{.State.Status}}' co1 and the output contains running
