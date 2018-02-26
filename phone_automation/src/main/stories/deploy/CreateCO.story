Scenario: Connect to case officer host
Given SSH connections:
| name   | remote-address | remotePort | username | password  |
| coHost | <<CO1_IP>>     | 22         | root     | !frqAdmin |

Scenario: Create case officer script
When the start case officer script is copied to coHost
And SSH host coHost executes chmod +x runCO.sh

Scenario: Start case officer
When SSH host coHost executes ./runCO.sh
Then waiting for 60 seconds
