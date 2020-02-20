Scenario: Connect to deploymentServer
Given SSH connections:
| name             | remote-address       | remotePort | username | password  |
| dockerHost1      | <<OPVOICE_HOST1_IP>> | 22         | root     | !frqAdmin |

Scenario: Kill Phone Routing service on docker host 1
When SSH host dockerHost1 executes docker kill phone-routing-service-1
Then waiting for 30 milliseconds

Scenario: Start Phone Routing service on docker host 1
When SSH host dockerHost1 executes docker start phone-routing-service-1
Then waiting for 30 seconds
When SSH host dockerHost1 executes docker inspect -f '{{.State.Status}}' phone-routing-service-1 and the output contains running


