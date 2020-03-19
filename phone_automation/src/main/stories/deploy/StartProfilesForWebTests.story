Scenario: Connect to case officer host
Given SSH connections:
| name   | remote-address | remotePort | username | password  |
| coHost | <<CO3_IP>>     | 22         | root     | !frqAdmin |

Scenario: Copy setup agent script
When the script setupSeleniumAgent from /configuration-files/<<systemName>>/ is copied to coHost
And SSH host coHost executes chmod +x setupSeleniumAgent.sh

Scenario: Run agent setup script
When SSH host coHost executes ./setupSeleniumAgent.sh

Scenario: Install profiles
When installing profiles:
| hostIp     | profile                    |
| <<CO3_IP>> | web/<<systemName>>/firefox |

Scenario: Start profiles
Given running profiles:
| hostIp     | profile                    | timeout        | nr |
| <<CO3_IP>> | web/<<systemName>>/firefox | <<Timeout|60>> | 1  |
Then waiting for 10 seconds

Scenario: Verify profiles
When verify profiles:
| hostIp     | profile                    | nr |
| <<CO3_IP>> | web/<<systemName>>/firefox | 1  |

