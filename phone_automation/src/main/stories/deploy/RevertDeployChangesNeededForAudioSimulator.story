Scenario: Connect to deploymentServer
Given SSH connections:
| name             | remote-address     | remotePort | username | password  |
| deploymentServer | <<DEP_SERVER_IP>>  | 22         | root     | !frqAdmin |

Scenario: Upload updated configuration file in Configuration Management Service for Op Voice Service
When using endpoint <<configurationMngEndpoint>> create configuration id op-voice-service
Then waiting for 3 seconds
And issuing http PUT request to endpoint <<configurationMngEndpoint>> and path configurations/op-voice-service/generic/items/partitions.json with payload /configuration-files/<<systemName>>/partitions.json

Scenario: Commit and activate configuration
When using endpoint <<configurationMngEndpoint>> commit the configuration and name commit commitId
Then waiting for 1 seconds
When activating commit commitId to endpoint <<configurationMngEndpoint>> and path configurations/activate
Then waiting for 3 seconds

Scenario: Publish the service descriptors and redeploy op-voice-service
Then SSH host deploymentServer executes /usr/bin/xvp services remove op-voice-service -g
Then SSH host deploymentServer executes /usr/bin/xvp services deploy --all -g
And waiting for 120 seconds
