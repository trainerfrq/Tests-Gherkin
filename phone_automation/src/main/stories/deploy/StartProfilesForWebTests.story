Scenario: Connect to case officer host
Given SSH connections:
| name   | remote-address | remotePort | username | password  |
| coHost | <<CO3_IP>>     | 22         | root     | !frqAdmin |

Scenario: Install profiles
When installing profiles:
| hostIp     | profile                    |
| <<CO3_IP>> | web/firefox_<<systemName>> |

Scenario: Start profiles
Given running profiles:
| hostIp     | profile                    | timeout        | nr |
| <<CO3_IP>> | web/firefox_<<systemName>> | <<Timeout|60>> | 1  |
Then waiting for 10 seconds

Scenario: Verify profiles
When verify profiles:
| hostIp     | profile                    | nr |
| <<CO3_IP>> | web/firefox_<<systemName>> | 1  |

