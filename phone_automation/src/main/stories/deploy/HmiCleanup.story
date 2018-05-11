Scenario: Connect to hosts
Given SSH connections:
| name             | remote-address    | remotePort | username | password  |
| deploymentServer | <<DEP_SERVER_IP>> | 22         | root     | !frqAdmin |

Scenario: Stop hmi
When SSH host deploymentServer executes /opt/frequentis/xvp-deployment/scripts/xvp remove voice_hmi03
When SSH host deploymentServer executes /opt/frequentis/xvp-deployment/scripts/xvp remove voice_hmi04
When SSH host deploymentServer executes /opt/frequentis/xvp-deployment/scripts/xvp remove voice_hmi05

