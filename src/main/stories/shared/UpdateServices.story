Scenario: Connect to depServer
Given SSH connections:
| name  | remote-address | remotePort | username | password  |
| sess1 |  <<DEP_SERVER_IP>>  | 22         | root     | !frqAdmin |

Scenario: Download latest images and update the services
When SSH host sess1 executes /opt/frequentis/xvp-deployment/scripts/xvp download
And SSH host sess1 executes ./clearRepo.sh
And SSH host sess1 executes /opt/frequentis/xvp-deployment/scripts/xvp deploy frequency_service
And SSH host sess1 executes /opt/frequentis/xvp-deployment/scripts/xvp deploy opvoice_service1
And SSH host sess1 executes /opt/frequentis/xvp-deployment/scripts/xvp deploy opvoice_service2

Scenario: Connect to Dockerhost
Given SSH connections:
| name  | remote-address     | remotePort | username | password  |
| sess2 | <<DOCKER_HOST_IP>> | 22         | root     | !frqAdmin |

Scenario: Check the service states
Then wait for 5 seconds
When SSH host sess2 executes docker ps | grep -i frequency and the output contains Up
When SSH host sess2 executes docker ps | grep -i opvoice and the output contains Up
