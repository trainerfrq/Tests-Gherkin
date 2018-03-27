Scenario: Connect to deploymentServer
Given SSH connections:
| name             | remote-address    | remotePort | username | password  |
| deploymentServer | <<DEP_SERVER_IP>> | 22         | root     | !frqAdmin |

Scenario: Stop HMIs
When SSH host deploymentServer executes /opt/frequentis/xvp-deployment/scripts/xvp remove voice_hmi03
And SSH host deploymentServer executes /opt/frequentis/xvp-deployment/scripts/xvp remove voice_hmi04
And SSH host deploymentServer executes /opt/frequentis/xvp-deployment/scripts/xvp remove voice_hmi05

Scenario: Start Op Voice Services
When SSH host deploymentServer executes /opt/frequentis/xvp-deployment/scripts/xvp deploy op_voice01
And SSH host deploymentServer executes /opt/frequentis/xvp-deployment/scripts/xvp deploy op_voice02
And SSH host deploymentServer executes /opt/frequentis/xvp-deployment/scripts/xvp deploy op_voice03
Then waiting for 20 seconds
!-- The audio app is redeployed as workaround for QXVP-7123
When SSH host deploymentServer executes /opt/frequentis/xvp-deployment/scripts/xvp deploy audio_app
Then waiting for 10 seconds

Scenario: Connect to hosts
Given xvp test system
And ssh connection to host DOC-VST02-11
And ssh connection to host DOC-VST02-12
And ssh connection to host DOC-VST02-13
Then verify that the services were started:
| serviceName | virtualMachineName | runningStatus |
| op_voice01  | DOC-VST02-11       | yes           |
| op_voice02  | DOC-VST02-12       | yes           |
| op_voice03  | DOC-VST02-13       | yes           |
