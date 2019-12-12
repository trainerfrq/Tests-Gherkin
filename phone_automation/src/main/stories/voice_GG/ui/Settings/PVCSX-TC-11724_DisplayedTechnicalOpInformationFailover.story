Meta:
@TEST_CASE_VERSION: V6
@TEST_CASE_NAME: TechnicalOpInformationWhileStoppingOPVoiceInstances
@TEST_CASE_DESCRIPTION: As an operator having a running HMI machine 
I want to stop the OP-Voice-Service instances and open the Maintenance window
So I can verify the information regarding the connections and OP-Voice-HMI version
@TEST_CASE_PRECONDITION: A HMI machine working properly
@TEST_CASE_PASS_FAIL_CRITERIA: The test is passed if the Maintenance window displays the required technical information
@TEST_CASE_DEVICES_IN_USE: 
@TEST_CASE_ID: PVCSX-TC-11724
@TEST_CASE_GLOBAL_ID: GID-5121757
@TEST_CASE_API_ID: 17163584

Scenario: Booking profiles
Given booked profiles:
| profile | group | host           | identifier |
| javafx  | hmi   | <<CLIENT1_IP>> | HMI OP1    |

Scenario: 1. Operator stops first OP-Voice-Service instance
Meta:
@TEST_STEP_ACTION: Operator stops first OP-Voice-Service instance
@TEST_STEP_REACTION: First OP-Voice-Service instance is closed
@TEST_STEP_REF: [CATS-REF: fvoy]
GivenStories: voice_GG/includes/KillOpVoiceActiveOnDockerHost1.story
When HMI OP1 verifies that loading screen is visible
And waiting for 60 seconds
Then HMI OP1 has in the DISPLAY STATUS section connection the state DEGRADED
And waiting for 5 seconds

Scenario: 2. Operator opens the Maintenance window
Meta:
@TEST_STEP_ACTION: Operator opens the Maintenance window
@TEST_STEP_REACTION: Maintenance window is open
@TEST_STEP_REF: [CATS-REF: aqNq]
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key SETTINGS
When HMI OP1 clicks on maintenancePanel button
Then HMI OP1 verifies that popup maintenance is visible

Scenario: 3. Operator checks the number of OP-Voice connections
Meta:
@TEST_STEP_ACTION: Operator checks the number of OP-Voice connections
@TEST_STEP_REACTION: The number of OP-Voice connections is the desired one
@TEST_STEP_REF: [CATS-REF: a9v1]
Then HMI OP1 verifies that the number of expecting connections is 2
Then HMI OP1 verifies that the number of available connections is 2

Scenario: 4. Operator checks the OP-Voice connections IPs and connectivity status
Meta:
@TEST_STEP_ACTION: Operator checks the OP-Voice connections IPs and connectivity status
@TEST_STEP_REACTION: The OP-Voice connections IPs are the desired ones and connections have the desired status
@TEST_STEP_REF: [CATS-REF: qzQI]
Then HMI OP1 verifies that connection number 1 of Op Voice instance <<OPVOICE1_WS.URI>> has status CONNECTING
Then HMI OP1 verifies that connection number 2 of Op Voice instance <<OPVOICE2_WS.URI>> has status ACTIVE

Scenario: 5. Operator stops second OP-Voice-Service instance
Meta:
@TEST_STEP_ACTION: Operator stops second OP-Voice-Service instance
@TEST_STEP_REACTION: Second OP-Voice-Service instance is closed
@TEST_STEP_REF: [CATS-REF: Vgig]
GivenStories: voice_GG/includes/KillOpVoiceActiveOnDockerHost2.story
When HMI OP1 verifies that loading screen is visible
Then HMI OP1 has in the DISPLAY STATUS section connection the state DISCONNECTED

Scenario: 6. Operator opens the Maintenance window
Meta:
@TEST_STEP_ACTION: Operator opens the Maintenance window
@TEST_STEP_REACTION: Maintenance window is open
@TEST_STEP_REF: [CATS-REF: uR6n]
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key SETTINGS
When HMI OP1 clicks on maintenancePanel button
Then HMI OP1 verifies that popup maintenance is visible

Scenario: 7. Operator checks the number of OP-Voice connections
Meta:
@TEST_STEP_ACTION: Operator checks the number of OP-Voice connections
@TEST_STEP_REACTION: The number of connections is the desired one
@TEST_STEP_REF: [CATS-REF: Ones]
Then HMI OP1 verifies that the number of expecting connections is 2
Then HMI OP1 verifies that the number of available connections is 2

Scenario: 8. Operator checks the OP-Voice connections IPs and connectivity status
Meta:
@TEST_STEP_ACTION: Operator checks the OP-Voice connections IPs and connectivity status
@TEST_STEP_REACTION: The OP-Voice connections IPs are the desired ones and connections have the desired status
@TEST_STEP_REF: [CATS-REF: UGUH]
Then HMI OP1 verifies that connection number 1 of Op Voice instance <<OPVOICE1_WS.URI>> has status CONNECTING
Then HMI OP1 verifies that connection number 2 of Op Voice instance <<OPVOICE2_WS.URI>> has status CONNECTING

Scenario: 9. Operator checks Voice-HMI version
Meta:
@TEST_STEP_ACTION: Operator checks Voice-HMI version
@TEST_STEP_REACTION: Displayed Voice-HMI version is the desired one
@TEST_STEP_REF: [CATS-REF: xX2x]
Then HMI OP1 verifies that version of OP-Voice-HMI version is the same with the version from /configuration-files/<<systemName>>/voice-hmi-service-docker-image.json

Scenario: Clean-up - Operator closes the Maintenance window
Then HMI OP1 closes maintenance popup
Then HMI OP1 verifies that popup maintenance is not visible
Then HMI OP1 verifies that popup settings is not visible

Scenario: Clean-up Operator starts OP-Voice-Service instances
GivenStories: voice_GG/includes/StartOpVoiceActiveOnDockerHost1.story,
			  voice_GG/includes/StartOpVoiceActiveOnDockerHost2.story
Then waiting for 60 seconds
Then HMI OP1 has in the DISPLAY STATUS section connection the state CONNECTED

Scenario: A scenario that is only executed in case of an execution failure
Meta: @RunOnFailure
GivenStories: voice_GG/ui/includes/@CleanupStory.story
Then waiting until the cleanup is done
