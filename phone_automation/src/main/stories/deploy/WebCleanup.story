Scenario: Connect to hosts
Given SSH connections:
| name   | remote-address | remotePort | username | password  |
| coHost | <<CO3_IP>>     | 22         | root     | !frqAdmin |

Scenario: Stop profiles
When stopping profiles:
| hostIp     | profile                    | timeout        | nr |
| <<CO3_IP>> | web/firefox_<<systemName>> | <<Timeout|60>> | 1  |
Then waiting for 5 seconds

Scenario: Stop case officer
When SSH host coHost executes ps aux | grep -v grep | grep caseofficer | awk '{print $2}'|xargs -r kill -9
Then waiting for 5 seconds
