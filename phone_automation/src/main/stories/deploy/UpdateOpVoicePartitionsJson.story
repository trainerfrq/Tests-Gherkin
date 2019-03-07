Scenario: Connect to deploymentServer
Given SSH connections:
| name             | remote-address       | remotePort | username | password  |
| catsMaster       | <<CATS_MASTER_IP>>   | 22         | root     | !frqAdmin |

Scenario: Upload updated configuration file in Configuration Management Service for Op Voice Service
When using endpoint <<configurationMngEndpoint>> create configuration id op-voice-service
Then waiting for 3 seconds
And issuing http PUT request to endpoint <<configurationMngEndpoint>> and path configurations/op-voice-service/items/partitions.json with payload /configuration-files/<<systemName>>/partitionsUpdated.json

Scenario: Commit and activate configuration
When using endpoint <<configurationMngEndpoint>> commit the configuration and name version versionId
Then waiting for 1 seconds
When activating version versionId to endpoint <<configurationMngEndpoint>> and path configurations/activate
