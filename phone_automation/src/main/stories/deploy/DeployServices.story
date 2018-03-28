Scenario: Upload configuration files in Configuration Management Service for Mission Service
When using endpoint <<configurationMngEndpoint>> create configuration id mission-service
Then waiting for 3 seconds
And issuing http PUT request to endpoint <<configurationMngEndpoint>> and path configurations/mission-service/items/opMissionsConfiguration.json with payload /configuration-files/<<systemName>>/opMissionsConfiguration.json

Scenario: Upload configuration files in Configuration Management Service for Op Voice Service
When using endpoint <<configurationMngEndpoint>> create configuration id op-voice-service
Then waiting for 3 seconds
And issuing http PUT request to endpoint <<configurationMngEndpoint>> and path configurations/op-voice-service/items/audioAppClient.json with payload /configuration-files/<<systemName>>/audioAppClient.json
And issuing http PUT request to endpoint <<configurationMngEndpoint>> and path configurations/op-voice-service/items/frequencyData.json with payload /configuration-files/<<systemName>>/frequencyData.json
And issuing http PUT request to endpoint <<configurationMngEndpoint>> and path configurations/op-voice-service/items/missions.json with payload /configuration-files/<<systemName>>/missions.json
And issuing http PUT request to endpoint <<configurationMngEndpoint>> and path configurations/op-voice-service/items/phoneData.json with payload /configuration-files/<<systemName>>/phoneData.json
And issuing http PUT request to endpoint <<configurationMngEndpoint>> and path configurations/op-voice-service/items/roles.json with payload /configuration-files/<<systemName>>/roles.json
And issuing http PUT request to endpoint <<configurationMngEndpoint>> and path configurations/op-voice-service/items/phoneBook.json with payload /configuration-files/<<systemName>>/phoneBook.json
And issuing http PUT request to endpoint <<configurationMngEndpoint>> and path configurations/op-voice-service/items/partitions.json with payload /configuration-files/<<systemName>>/partitions.json

Scenario: Commit and activate configuration
When using endpoint <<configurationMngEndpoint>> commit the configuration and name version versionId
Then waiting for 1 seconds
When activating version versionId to endpoint <<configurationMngEndpoint>> and path configurations/activate
Then waiting for 3 seconds

Scenario: Connect to deploymentServer
Given SSH connections:
| name             | remote-address      | remotePort | username | password  |
| deploymentServer | <<DEP_SERVER_IP>>   | 22         | root     | !frqAdmin |
| dockerHost1      | <<DOCKER_HOST1_IP>> | 22         | root     | !frqAdmin |
| dockerHost2      | <<DOCKER_HOST2_IP>> | 22         | root     | !frqAdmin |
| dockerHost3      | <<DOCKER_HOST3_IP>> | 22         | root     | !frqAdmin |
| hmiHost1         | <<CO1_IP>>          | 22         | root     | !frqAdmin |
| hmiHost2         | <<CO2_IP>>          | 22         | root     | !frqAdmin |
| hmiHost3         | <<CLIENT3_IP>>      | 22         | root     | !frqAdmin |

Scenario: Update services
When the services are updated on deploymentServer with ${op.voice.version} and ${voice.hmi.version}
Then SSH host deploymentServer executes /opt/frequentis/xvp-deployment/scripts/xvp download

Scenario: Stop services
When SSH host deploymentServer executes /opt/frequentis/xvp-deployment/scripts/xvp remove mission_service
And SSH host deploymentServer executes /opt/frequentis/xvp-deployment/scripts/xvp remove phone_routing
And SSH host deploymentServer executes /opt/frequentis/xvp-deployment/scripts/xvp remove audio_service
And SSH host deploymentServer executes /opt/frequentis/xvp-deployment/scripts/xvp remove audio_app
And SSH host deploymentServer executes /opt/frequentis/xvp-deployment/scripts/xvp remove voice_hmi03
And SSH host deploymentServer executes /opt/frequentis/xvp-deployment/scripts/xvp remove voice_hmi04
And SSH host deploymentServer executes /opt/frequentis/xvp-deployment/scripts/xvp remove voice_hmi05

Scenario: Start services
When SSH host deploymentServer executes /opt/frequentis/xvp-deployment/scripts/xvp deploy mission_service
Then waiting for 5 seconds
When SSH host deploymentServer executes /opt/frequentis/xvp-deployment/scripts/xvp deploy phone_routing
Then waiting for 5 seconds
When SSH host deploymentServer executes /opt/frequentis/xvp-deployment/scripts/xvp deploy audio_service
Then waiting for 5 seconds
When SSH host deploymentServer executes /opt/frequentis/xvp-deployment/scripts/xvp deploy audio_app
Then waiting for 5 seconds

Scenario: Verify services are running on deploymentServer
When SSH host deploymentServer executes docker inspect -f '{{.State.Status}}' phone-routing and the output contains running

Scenario: Verify services are running on dockerhost1
When SSH host dockerHost1 executes docker inspect -f '{{.State.Status}}' mission-service and the output contains running
When SSH host dockerHost1 executes docker inspect -f '{{.State.Status}}' audio-service and the output contains running

Scenario: Verify services are running on dockerhost2
When SSH host dockerHost2 executes docker inspect -f '{{.State.Status}}' mission-service and the output contains running
When SSH host dockerHost2 executes docker inspect -f '{{.State.Status}}' audio-service and the output contains running

Scenario: Verify services are running on dockerhost3
When SSH host dockerHost3 executes docker inspect -f '{{.State.Status}}' audio-service and the output contains running

Scenario: Verify services are running on hmiHost1
When SSH host hmiHost1 executes docker inspect -f '{{.State.Status}}' audio-app and the output contains running

Scenario: Verify services are running on hmiHost2
When SSH host hmiHost2 executes docker inspect -f '{{.State.Status}}' audio-app and the output contains running

Scenario: Verify services are running on hmiHost3
When SSH host hmiHost3 executes docker inspect -f '{{.State.Status}}' audio-app and the output contains running
