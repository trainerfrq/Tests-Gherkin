Scenario: Connect to host
Given SSH connections:
| name  | remote-address | remotePort | username | password  |
| sess1 | <<HOST_IP>>    | 22         | root     | !frqAdmin |

Scenario: create CO
When SSH host sess1 executes ./runCO.sh

Then waiting for 30 seconds
