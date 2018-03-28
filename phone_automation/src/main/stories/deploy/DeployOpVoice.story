Scenario: Connect to deploymentServer
Given SSH connections:
| name             | remote-address      | remotePort | username | password  |
| deploymentServer | <<DEP_SERVER_IP>>   | 22         | root     | !frqAdmin |
| dockerHost1      | <<DOCKER_HOST1_IP>> | 22         | root     | !frqAdmin |
| dockerHost2      | <<DOCKER_HOST2_IP>> | 22         | root     | !frqAdmin |
| dockerHost3      | <<DOCKER_HOST3_IP>> | 22         | root     | !frqAdmin |

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

Scenario: Verify Op Voice Services are running
When SSH host dockerHost1 executes docker inspect -f '{{.State.Status}}' op-voice01 and the output contains running
When SSH host dockerHost2 executes docker inspect -f '{{.State.Status}}' op-voice02 and the output contains running
When SSH host dockerHost3 executes docker inspect -f '{{.State.Status}}' op-voice03 and the output contains running
