Meta:
@TEST_CASE_VERSION: V23
@TEST_CASE_NAME: DisplayedTechnicalOpInformation
@TEST_CASE_DESCRIPTION: As an operator
I want to open the Maintenance window
So I can verify the information regarding the Op Voice connections and OP-Voice-HMI version
@TEST_CASE_PRECONDITION: An operator with a HMI that is working properly
Both OP-Voice-Service instances must be stopped and restarted in the next order:
1. First instance of OP-Voice-Service
2. Second instance of OP-Voice-Service
@TEST_CASE_PASS_FAIL_CRITERIA: The test is passed if the Maintenance window displays the required technical information
@TEST_CASE_DEVICES_IN_USE: 
@TEST_CASE_ID: PVCSX-TC-11712
@TEST_CASE_GLOBAL_ID: GID-5115029
@TEST_CASE_API_ID: 17111287

Scenario: Booking profiles
Given booked profiles:
| profile | group | host           | identifier |
| javafx  | hmi   | <<CLIENT1_IP>> | HMI OP1    |

Scenario: Precondition - Restart OP-Voice-Service instances
GivenStories: voice_GG/includes/KillStartOpVoiceActiveOnDockerHost1.story,
			  voice_GG/includes/KillStartOpVoiceActiveOnDockerHost2.story
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

Scenario: 2. Operator checks the number of expected OP-Voice connections
Meta:
@TEST_STEP_ACTION: Operator checks the number of expected OP-Voice connections
@TEST_STEP_REACTION: The number of expected OP-Voice connections is the desired one
@TEST_STEP_REF: [CATS-REF: Tqwl]
Then HMI OP1 verifies that the number of expecting connections is 2

Scenario: 3. Operator checks the number of available OP-Voice connections
Meta:
@TEST_STEP_ACTION: Operator checks the number of available OP-Voice connections
@TEST_STEP_REACTION: The number of available OP-VOice connections is the desired one
@TEST_STEP_REF: [CATS-REF: mDqb]
Then HMI OP1 verifies that the number of available connections is 2

Scenario: 4. Operator checks the OP-Voice connections IPs and connectivity status
Meta:
@TEST_STEP_ACTION: Operator checks the OP-Voice connections IPs and connectivity status
@TEST_STEP_REACTION: The OP-Voice connections IPs are the desired ones and connections have the desired status
@TEST_STEP_REF: [CATS-REF: auE9]
Then HMI OP1 verifies that connection number 1 of Op Voice instance <<OPVOICE1_WS.URI>> has status ACTIVE
Then HMI OP1 verifies that connection number 2 of Op Voice instance <<OPVOICE2_WS.URI>> has status PASSIVE

Scenario: 5. Operator checks Voice-HMI version
Meta:
@TEST_STEP_ACTION: Operator checks Voice-HMI version
@TEST_STEP_REACTION: Displayed Voice-HMI version is the desired one
@TEST_STEP_REF: [CATS-REF: a3sA]
Then HMI OP1 verifies that version of OP-Voice-HMI version is the same with the version from /configuration-files/<<systemName>>/voice-hmi-service-docker-image.json

Scenario: Clean-up - Operator closes the Maintenance window
Then HMI OP1 closes maintenance popup
Then HMI OP1 verifies that popup maintenance is not visible
Then HMI OP1 verifies that popup settings is not visible

Scenario: A scenario that is only executed in case of an execution failure
Meta: @RunOnFailure
GivenStories: voice_GG/ui/includes/@CleanupStory.story
Then waiting until the cleanup is done
