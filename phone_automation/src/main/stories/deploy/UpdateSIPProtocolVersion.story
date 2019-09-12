Scenario: Connect to deploymentServer
Given SSH connections:
| name             | remote-address      | remotePort | username | password  |
| deploymentServer | <<DEP_SERVER_IP>>   | 22         | root     | !frqAdmin |

Scenario: Change SIP protocol version in Configuration Management Service
When issuing http POST request to endpoint <<configurationMngEndpoint>> and path configurations/op-voice-service/phone with payload /configuration-files/common/audioAppResources.json
When issuing http POST request to endpoint <<configurationMngEndpoint>> and path configurations/op-voice-service/phone with property ED-137/2B true and ED-137/2C true

Scenario: Commit and activate configuration
When using endpoint <<configurationMngEndpoint>> commit the configuration and name commit commitId
Then waiting for 1 seconds
When activating commit commitId to endpoint <<configurationMngEndpoint>> and path configurations/activate
Then waiting for 3 seconds
