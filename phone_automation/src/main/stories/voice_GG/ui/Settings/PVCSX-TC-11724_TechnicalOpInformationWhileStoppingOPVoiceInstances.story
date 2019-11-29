Meta:
@TEST_CASE_VERSION: V5
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
| javafx  | hmi   | <<CLIENT2_IP>> | HMI OP2    |
| javafx  | hmi   | <<CLIENT3_IP>> | HMI OP3    |

Scenario: Operator stops OPVOICE1_IP OP-Voice-Service instance
Meta:
@TEST_STEP_ACTION: Operator stops first OP-Voice -Service instance
@TEST_STEP_REACTION: First OP-Voice-Service instance is closed
@TEST_STEP_REF: [CATS-REF: fvoy]
GivenStories: voice_GG/includes/KillOpVoiceActiveOnDockerHost1.story
When HMI OP1 verifies that loading screen is visible
Then HMI OP1 has in the DISPLAY STATUS section connection the state DEGRADED
And waiting for 5 seconds

Scenario: Operator opens the Maintenance window
Meta:
@TEST_STEP_ACTION: Operator opens the Maintenance window
@TEST_STEP_REACTION: 	Maintenance window is open
@TEST_STEP_REF: [CATS-REF: aqNq]
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key SETTINGS
When HMI OP1 clicks on maintenancePanel button
Then HMI OP1 verifies that popup maintenance is visible

Scenario: Operator checks the number of connections
Meta:
@TEST_STEP_ACTION: 	Operator checks the number of connections
@TEST_STEP_REACTION: 	The number of connections is the desired one
@TEST_STEP_REF: [CATS-REF: a9v1]
Then HMI OP1 verifies that the number of expecting connections is <<EXPECTED_CONNECTIONS>>
Then HMI OP1 verifies that the number of available connections is <<AVAILABLE_CONNECTIONS>>

Scenario: Operator checks the connections IPs and the connectivity status
Meta:
@TEST_STEP_ACTION: Operator checks the connections IPs and the connectivity status
@TEST_STEP_REACTION: The IPs are the desired ones with the desired status
@TEST_STEP_REF: [CATS-REF: qzQI]
Then HMI OP1 verifies that connection number 1 with IP <<OPVOICE2_IP>> has status ACTIVE
Then HMI OP1 verifies that connection number 2 with IP <<OPVOICE1_IP>> has status CONNECTING

Scenario: Operator checks OP-Voice-HMI version
Meta:
@TEST_STEP_ACTION: 	Operator checks OP-Voice-HMI version 
@TEST_STEP_REACTION: Displayed OP-Voice-HMI version is the desired one
@TEST_STEP_REF: [CATS-REF: rX1Q]
Then HMI OP1 verifies that version of OP-Voice-HMI version is the same with the version from /configuration-files/<<systemName>>/voice-hmi-service-docker-image.json

Scenario: Operator stops OPVOICE2_IP OP-Voice-Service instance
Meta:
@TEST_STEP_ACTION: Operator stops second OP-Voice-Service instance
@TEST_STEP_REACTION: Second OP-Voice-Service instance is closed
@TEST_STEP_REF: [CATS-REF: Vgig]
GivenStories: voice_GG/includes/KillOpVoiceActiveOnDockerHost2.story
When HMI OP1 verifies that loading screen is visible
Then HMI OP1 has in the DISPLAY STATUS section connection the state DISCONNECTED

Scenario: Operator opens the Maintenance window
Meta:
@TEST_STEP_ACTION: Operator opens the Maintenance window
@TEST_STEP_REACTION: Maintenance window is open
@TEST_STEP_REF: [CATS-REF: uR6n]
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key SETTINGS
When HMI OP1 clicks on maintenancePanel button
Then HMI OP1 verifies that popup maintenance is visible

Scenario: Operator checks the number of connections
Meta:
@TEST_STEP_ACTION: Operator checks the number of connections
@TEST_STEP_REACTION: The number of connections is the desired one
@TEST_STEP_REF: [CATS-REF: Ones]
Then HMI OP1 verifies that the number of expecting connections is <<EXPECTED_CONNECTIONS>>
Then HMI OP1 verifies that the number of available connections is <<AVAILABLE_CONNECTIONS>>

Scenario: Operator checks the connections IPs and the connectivity status
Meta:
@TEST_STEP_ACTION: Operator checks the connections IPs and the connectivity status
@TEST_STEP_REACTION: 	The IPs are the desired ones with the desired status
@TEST_STEP_REF: [CATS-REF: UGUH]
Then HMI OP1 verifies that connection number 1 with IP <<OPVOICE2_IP>> has status CONNECTING
Then HMI OP1 verifies that connection number 2 with IP <<OPVOICE1_IP>> has status CONNECTING

Scenario: Operator checks OP-Voice-HMI version
Meta:
@TEST_STEP_ACTION: Operator checks OP-Voice-HMI version 
@TEST_STEP_REACTION: Displayed OP-Voice version is the desired one
@TEST_STEP_REF: [CATS-REF: xX2x]
Then HMI OP1 verifies that version of OP-Voice-HMI version is the same with the version from /configuration-files/<<systemName>>/voice-hmi-service-docker-image.json

Scenario: Clean-up - Operator closes the Maintenance window
Then HMI OP1 closes maintenance popup

Scenario: Clean-up Operator starts OPVOICE1_IP OP Voice instance
GivenStories: voice_GG/includes/StartOpVoiceActiveOnDockerHost1.story
Then waiting for 60 seconds
Then HMI OP1 has in the DISPLAY STATUS section connection the state DEGRADED

Scenario: Clean-up Operator starts OPVOICE2_IP OP Voice instance
GivenStories: voice_GG/includes/StartOpVoiceActiveOnDockerHost2.story
Then waiting for 60 seconds
Then HMI OP1 has in the DISPLAY STATUS section connection the state CONNECTED
