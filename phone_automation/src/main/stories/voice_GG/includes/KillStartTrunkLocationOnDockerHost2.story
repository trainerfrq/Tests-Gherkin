Scenario: Connect to deploymentServer
Given SSH connections:
| name             | remote-address       | remotePort | username | password  |
| dockerHost2      | <<OPVOICE_HOST2_IP>> | 22         | root     | !frqAdmin |

Scenario: Kill Trunk Location service on docker host 2
When SSH host dockerHost2 executes docker kill trunk-location-service-2
Then waiting for 30 milliseconds

Scenario: Start Trunk Location service on docker host 2
When SSH host dockerHost2 executes docker start trunk-location-service-2
Then waiting for 1 second
When SSH host dockerHost2 executes docker inspect -f '{{.State.Status}}' trunk-location-service-2 and the output contains running


