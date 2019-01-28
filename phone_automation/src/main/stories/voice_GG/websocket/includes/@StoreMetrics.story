Scenario: Connect to deploymentServer
Given SSH connections:
| name             | remote-address       | remotePort | username | password  |
| catsMaster       | <<CATS_MASTER_IP>>   | 22         | root     | !frqAdmin |

Given the id of the cats-master docker container is taken from catsMaster
Then the timer values are stored outside the container on catsMaster
