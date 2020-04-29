Meta:
@TEST_CASE_VERSION: V27
@TEST_CASE_NAME: DisplayedTechnicalOpInformation
@TEST_CASE_DESCRIPTION: As an operator
I want to open the Maintenance window
So I can verify the information regarding the Op Voice connections and OP-Voice-HMI version
@TEST_CASE_PRECONDITION:
-OP-Voice service instance 1 of OP1 is ACTIVE
-OP-Voice service instance 2 of OP1 is PASSIVE
@TEST_CASE_PASS_FAIL_CRITERIA: The test is passed if the Maintenance window displays:
- Number of connected OP-Voice connections
- Status and IP of the OP-Voice connections
- Current HMI version
@TEST_CASE_DEVICES_IN_USE: OP1
@TEST_CASE_ID: PVCSX-TC-11712
@TEST_CASE_GLOBAL_ID: GID-5115029
@TEST_CASE_API_ID: 17111287

Scenario: Booking profiles
Given booked profiles:
| profile | group | host           | identifier |
| javafx  | hmi   | <<CLIENT1_IP>> | HMI OP1    |
| javafx  | hmi   | <<CLIENT2_IP>> | HMI OP2    |
| javafx  | hmi   | <<CLIENT3_IP>> | HMI OP3    |
| websocket | hmi | <<CO3_IP>>     | WEBSOCKET  |

Scenario: Precondition - find the passive and the active instance
Given named the websocket configurations:
| named       | websocket-uri       | text-buffer-size |
| WS_Config-1 | <<OPVOICE1_WS.URI>> | 1000             |
| WS_Config-2 | <<OPVOICE2_WS.URI>> | 1000             |

Given applied the websocket configuration:
| profile-name | websocket-config-name |
| WEBSOCKET 1  | WS_Config-1           |
| WEBSOCKET 1  | WS_Config-2           |

Scenario: 1. OP1 opens the Maintenance window
Meta:
@TEST_STEP_ACTION: OP1 opens the Maintenance window
@TEST_STEP_REACTION: Maintenance window is open
@TEST_STEP_REF: [CATS-REF: PHdp]
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key SETTINGS
When HMI OP1 clicks on maintenancePanel button
Then HMI OP1 verifies that popup maintenance is visible

Scenario: 2. OP1 checks the number of "Expected connections:"
Meta:
@TEST_STEP_ACTION: OP1 checks the number of "Expected connections:"
@TEST_STEP_REACTION: The number of "Expected connections" is 2
@TEST_STEP_REF: [CATS-REF: Tqwl]
Then HMI OP1 verifies that the number of expecting connections is 2

Scenario: 3. OP1 checks the number of "Available connections:"
Meta:
@TEST_STEP_ACTION: OP1 checks the number of "Available connections:"
@TEST_STEP_REACTION: The number of "Available connections" is 2
@TEST_STEP_REF: [CATS-REF: mDqb]
Then HMI OP1 verifies that the number of available connections is 2

Scenario: 4. OP1 checks the OP-Voice connections IPs and connectivity status
Meta:
@TEST_STEP_ACTION: OP1 checks the OP-Voice connections IPs and connectivity status
@TEST_STEP_REACTION: The OP-Voice connections IPs are displayed
@TEST_STEP_REF: [CATS-REF: auE9]
Then HMI OP1 verifies that Op Voice URI <<OPVOICE1_WS.URI>> is visible in the connections area
Then HMI OP1 verifies that Op Voice URI <<OPVOICE2_WS.URI>> is visible in the connections area

Scenario: 4.1 Check first instance status and IP
Meta:
@TEST_STEP_ACTION: -
@TEST_STEP_REACTION: Connection 1 displays ACTIVE
@TEST_STEP_REF: [CATS-REF: abE2]
Then HMI OP1 verifies that Op Voice URI <<OPVOICE1_WS.URI>> has the expected status

Scenario: 4.2 Check second instance status and IP
Meta:
@TEST_STEP_ACTION: -
@TEST_STEP_REACTION: Connection 2 displays PASSIVE
@TEST_STEP_REF: [CATS-REF: bbq1]
Then HMI OP1 verifies that Op Voice URI <<OPVOICE2_WS.URI>> has the expected status

Scenario: 5. OP1 checks Voice-HMI version
Meta:
@TEST_STEP_ACTION: OP1 checks Voice-HMI version
@TEST_STEP_REACTION: Current Voice-HMI version is displayed
@TEST_STEP_REF: [CATS-REF: a3sA]
Then HMI OP1 verifies that version of OP-Voice-HMI version is the same with the version from /configuration-files/<<systemName>>/voice-hmi-service-docker-image.json

Scenario: Clean-up - OP1 closes the Maintenance window
Then HMI OP1 closes maintenance popup
Then HMI OP1 verifies that popup maintenance is not visible
Then HMI OP1 verifies that popup settings is not visible

Scenario: A scenario that is only executed in case of an execution failure
Meta: @RunOnFailure
GivenStories: voice_GG/ui/includes/@CleanupStory.story
Then waiting until the cleanup is done
