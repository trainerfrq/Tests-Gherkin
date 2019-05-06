Scenario: Connect to deploymentServer
Given SSH connections:
| name             | remote-address      | remotePort | username | password  |
| deploymentServer | <<DEP_SERVER_IP>>   | 22         | root     | !frqAdmin |
| dockerHost1      | <<DOCKER_HOST1_IP>> | 22         | root     | !frqAdmin |
| dockerHost2      | <<DOCKER_HOST2_IP>> | 22         | root     | !frqAdmin |
| dockerHost3      | <<DOCKER_HOST3_IP>> | 22         | root     | !frqAdmin |
| hmiHost1         | <<CLIENT1_IP>>      | 22         | root     | !frqAdmin |
| hmiHost2         | <<CLIENT2_IP>>      | 22         | root     | !frqAdmin |
| hmiHost3         | <<CLIENT3_IP>>      | 22         | root     | !frqAdmin |

Scenario: Upload configuration files in Configuration Management Service for Op Voice Service
When using endpoint <<configurationMngEndpoint>> create configuration id op-voice-service
Then waiting for 3 seconds
And issuing http PUT request to endpoint <<configurationMngEndpoint>> and path configurations/op-voice-service/items/audioAppClient.json with payload /configuration-files/common/audioAppClient.json
And issuing http PUT request to endpoint <<configurationMngEndpoint>> and path configurations/op-voice-service/items/frequencyData.json with payload /configuration-files/common/frequencyData.json
And issuing http PUT request to endpoint <<configurationMngEndpoint>> and path configurations/op-voice-service/items/virtualDevices.json with payload /configuration-files/common/virtualDevices.json
And issuing http PUT request to endpoint <<configurationMngEndpoint>> and path configurations/op-voice-service/items/missions.json with payload /configuration-files/<<systemName>>/missions.json
And issuing http PUT request to endpoint <<configurationMngEndpoint>> and path configurations/op-voice-service/items/phoneData.json with payload /configuration-files/<<systemName>>/phoneData.json
And issuing http PUT request to endpoint <<configurationMngEndpoint>> and path configurations/op-voice-service/items/layouts.json with payload /configuration-files/<<systemName>>/layouts.json
And issuing http PUT request to endpoint <<configurationMngEndpoint>> and path configurations/op-voice-service/items/phoneBook.json with payload /configuration-files/<<systemName>>/phoneBook.json
And issuing http PUT request to endpoint <<configurationMngEndpoint>> and path configurations/op-voice-service/items/partitions.json with payload /configuration-files/<<systemName>>/partitions.json
And issuing http PUT request to endpoint <<configurationMngEndpoint>> and path configurations/op-voice-service/items/phoneDevices.json with payload /configuration-files/<<systemName>>/phoneDevices.json
And issuing http PUT request to endpoint <<configurationMngEndpoint>> and path configurations/op-voice-service/items/radioData.json with payload /configuration-files/<<systemName>>/radioData.json
And issuing http PUT request to endpoint <<configurationMngEndpoint>> and path configurations/op-voice-service/items/physicalDevices.json with payload /configuration-files/common/physicalDevices.json
And issuing http PUT request to endpoint <<configurationMngEndpoint>> and path configurations/op-voice-service/items/recordingDevices.json with payload /configuration-files/common/recordingDevices.json
And issuing http PUT request to endpoint <<configurationMngEndpoint>> and path configurations/op-voice-service/items/recordingDevices.json with payload /configuration-files/common/radioLoudspeakerAudioState.json
And issuing http PUT request to endpoint <<configurationMngEndpoint>> and path configurations/op-voice-service/items/audibleTones.json with payload /configuration-files/common/audibleTones.json
And issuing http PUT request to endpoint <<configurationMngEndpoint>> and path configurations/op-voice-service/items/footSwitch.json with payload /configuration-files/common/footSwitch.json
And issuing http PUT request to endpoint <<configurationMngEndpoint>> and path configurations/op-voice-service/items/couplingGroups.json with payload /configuration-files/common/couplingGroups.json

Scenario: Upload configuration files in Configuration Management Service for Phone Routing Service
When using endpoint <<configurationMngEndpoint>> create configuration id phone-routing
Then waiting for 3 seconds
And issuing http PUT request to endpoint <<configurationMngEndpoint>> and path configurations/phone-routing/items/callRoutes.json with payload /configuration-files/common/callRoutes.json

Scenario: Commit and activate configuration
When using endpoint <<configurationMngEndpoint>> commit and activate the configuration in path configurations/activate
!-- TODO Uncomment steps when CATS is upgraded to 5.4
!-- When using endpoint <<configurationMngEndpoint>> commit the configuration and name commit commitId
!-- Then waiting for 1 seconds
!-- When activating commit commitId to endpoint <<configurationMngEndpoint>> and path configurations/activate
Then waiting for 3 seconds

Scenario: Stop services
When SSH host deploymentServer executes /usr/bin/xvp services remove phone-routing -g
Then waiting for 5 seconds
When SSH host deploymentServer executes /usr/bin/xvp services remove audio-service -g
Then waiting for 5 seconds
When SSH host deploymentServer executes /usr/bin/xvp services remove mission-service -g
Then waiting for 5 seconds

Scenario: Stop audio-app on all hosts
When SSH host hmiHost1 executes docker rm -f audio-app
Then waiting for 5 seconds
When SSH host hmiHost2 executes docker rm -f audio-app
Then waiting for 5 seconds
When SSH host hmiHost3 executes docker rm -f audio-app
Then waiting for 5 seconds

Scenario: Stop all running voice-hmi services
When SSH host hmiHost1 executes docker rm -f $(docker ps -q -a -f name=${PARTITION_KEY_1})
And waiting for 5 seconds
When SSH host hmiHost2 executes docker rm -f $(docker ps -q -a -f name=${PARTITION_KEY_2})
And waiting for 5 seconds
When SSH host hmiHost3 executes docker rm -f $(docker ps -q -a -f name=${PARTITION_KEY_3})
And waiting for 5 seconds

Scenario: Start servies
Then SSH host deploymentServer executes /usr/bin/xvp services deploy --all -g
And waiting for 30 seconds

Scenario: Start audio-app on host 1
When the launch audio app script is copied to hmiHost1 and updated with ${AUDIO_MACVLANDATA_HOST1_IP} and ${AUDIO_MACVLANDAUDIO_HOST1_IP}
And SSH host hmiHost1 executes chmod +x launchAudioApp.sh
And SSH host hmiHost1 executes ./launchAudioApp.sh

Scenario: Start audio-app on host 2
When the launch audio app script is copied to hmiHost2 and updated with ${AUDIO_MACVLANDATA_HOST2_IP} and ${AUDIO_MACVLANDAUDIO_HOST2_IP}
And SSH host hmiHost2 executes chmod +x launchAudioApp.sh
And SSH host hmiHost2 executes ./launchAudioApp.sh

Scenario: Start audio-app on host 3
When the launch audio app script is copied to hmiHost3 and updated with ${AUDIO_MACVLANDATA_HOST3_IP} and ${AUDIO_MACVLANDAUDIO_HOST3_IP}
And SSH host hmiHost3 executes chmod +x launchAudioApp.sh
And SSH host hmiHost3 executes ./launchAudioApp.sh
And waiting for 10 seconds

Scenario: Verify audio-app is running on hmiHost1
When SSH host hmiHost1 executes docker inspect -f '{{.State.Status}}' audio-app and the output contains running

Scenario: Verify audio-app is running on hmiHost2
When SSH host hmiHost2 executes docker inspect -f '{{.State.Status}}' audio-app and the output contains running

Scenario: Verify audio-app is running on hmiHost3
When SSH host hmiHost3 executes docker inspect -f '{{.State.Status}}' audio-app and the output contains running

