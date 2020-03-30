Scenario: Connect to case officer host
Given SSH connections:
| name   | remote-address | remotePort | username | password  |
| coHost | <<CO3_IP>>     | 22         | root     | !frqAdmin |

Scenario: Stop case officer
When SSH host coHost executes ps aux | grep -v grep | grep caseofficer | awk '{print $2}'|xargs -r kill -9
Then waiting for 5 seconds

Scenario: Copy setup case officer script
When the script setupCO from /configuration-files/<<systemName>>/ is copied to coHost
And SSH host coHost executes chmod +x setupCO.sh

Scenario: Run setup script
When SSH host coHost executes ./setupCO.sh

Scenario: Copy start case officer script
When the script runCO_noDocker from /configuration-files/<<systemName>>/ is copied to coHost
And SSH host coHost executes chmod +x runCO_noDocker.sh

Scenario: Run start case officer script
When SSH host coHost executes ./runCO_noDocker.sh
Then waiting for 60 seconds

Scenario: Verify case officer is running
When SSH host coHost executes ps aux | grep -v grep | grep caseofficer and the output contains caseofficer
