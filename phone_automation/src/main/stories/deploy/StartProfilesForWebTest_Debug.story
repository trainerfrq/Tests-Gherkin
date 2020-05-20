Scenario: Connect to case officer host
Given SSH connections:
| name   | remote-address | remotePort | username | password  |
| coHost | <<CO3_IP>>     | 22         | root     | !frqAdmin |

Scenario: Create Firefox debug container
When SSH host coHost executes docker run -d -p 4445:4444 -p 5910:5900 -v /dev/shm:/dev/shm selenium/standalone-firefox-debug:3.141.59-20200409

Scenario: Install profiles
When installing profiles:
| hostIp     | profile                          |
| <<CO3_IP>> | web/firefox_<<systemName>>_debug |

Scenario: Start profiles
Given running profiles:
| hostIp     | profile                          | timeout        | nr |
| <<CO3_IP>> | web/firefox_<<systemName>>_debug | <<Timeout|60>> | 1  |
Then waiting for 10 seconds

Scenario: Verify profiles
When verify profiles:
| hostIp     | profile                          | nr |
| <<CO3_IP>> | web/firefox_<<systemName>>_debug | 1  |

