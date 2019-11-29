Meta:
@TEST_CASE_VERSION: V13
@TEST_CASE_NAME: DisplayedTechnicalOpInformation
@TEST_CASE_DESCRIPTION: As an operator having a working HMI machine
I want to open the Maintenance window
So I can verify the information regarding the connections and OP-Voice-HMI version
@TEST_CASE_PRECONDITION: An operator with a HMI that is working properly
Both OP-Voice-Service instances must be stopped and restarted in the next order:
1. OP-Voice-Service with ip: OPVOICE1_IP
2. OP-Voice-Service with ip: OPVOICE2_IP
@TEST_CASE_PASS_FAIL_CRITERIA: The test is passed if the Maintenance window displays the required technical information
@TEST_CASE_DEVICES_IN_USE: 
@TEST_CASE_ID: PVCSX-TC-11712
@TEST_CASE_GLOBAL_ID: GID-5115029
@TEST_CASE_API_ID: 17111287

Scenario: Booking profiles
Given booked profiles:
| profile | group | host           | identifier |
| javafx  | hmi   | <<CLIENT1_IP>> | HMI OP1    |
| javafx  | hmi   | <<CLIENT2_IP>> | HMI OP2    |
| javafx  | hmi   | <<CLIENT3_IP>> | HMI OP3    |

Scenario: Precondition - Restart OPVOICE1_IP OP-Voice-Services
GivenStories: voice_GG/includes/KillStartOpVoiceActiveOnDockerHost1.story
Then waiting for 60 seconds
Then HMI OP1 has in the DISPLAY STATUS section connection the state CONNECTED

Scenario: Precondition - Restart OPVOICE2_IP OP-Voice-Services
GivenStories: voice_GG/includes/KillStartOpVoiceActiveOnDockerHost2.story
Then waiting for 60 seconds
Then HMI OP1 has in the DISPLAY STATUS section connection the state CONNECTED

Scenario: 1. Operator opens the Maintenance window
Meta:
@TEST_STEP_ACTION: Operator opens the Maintenance window
@TEST_STEP_REACTION: Maintenance window is open
@TEST_STEP_REF: [CATS-REF: PHdp]
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key SETTINGS
When HMI OP1 clicks on maintenancePanel button
Then HMI OP1 verifies that popup maintenance is visible

Scenario: 2. Operator checks the number of expected connections
Meta:
@TEST_STEP_ACTION: Operator checks the number of expected connections
@TEST_STEP_REACTION: The number of expected connections is the desired one 
@TEST_STEP_REF: [CATS-REF: Tqwl]
Then HMI OP1 verifies that the number of expecting connections is <<EXPECTED_CONNECTIONS>>

Scenario: 3. Operator checks the number of available connections
Meta:
@TEST_STEP_ACTION: Operator checks the number of available connections
@TEST_STEP_REACTION: The number of available connections is the desired one
@TEST_STEP_REF: [CATS-REF: mDqb]
Then HMI OP1 verifies that the number of available connections is <<AVAILABLE_CONNECTIONS>>

Scenario: 4. Operator checks the connections IPs and the connectivity status
Meta:
@TEST_STEP_ACTION: Operator checks the connections IPs and the connectivity status
@TEST_STEP_REACTION: The IPs are the desired ones with the desired status
@TEST_STEP_REF: [CATS-REF: auE9]
Then HMI OP1 verifies that connection number 1 with IP <<OPVOICE2_IP>> has status PASSIVE
Then HMI OP1 verifies that connection number 2 with IP <<OPVOICE1_IP>> has status ACTIVE

Scenario: 5. Operator checks OP-Voice-HMI version
Meta:
@TEST_STEP_ACTION: Operator checks OP-Voice version 
@TEST_STEP_REACTION: Displayed OP-Voice version is the desired one
@TEST_STEP_REF: [CATS-REF: a3sA]
Then HMI OP1 verifies that version of OP-Voice-HMI version is the same with the version from /configuration-files/<<systemName>>/voice-hmi-service-docker-image.json

Scenario: Clean-up - Operator closes the Maintenance window
Then HMI OP1 closes maintenance popup


