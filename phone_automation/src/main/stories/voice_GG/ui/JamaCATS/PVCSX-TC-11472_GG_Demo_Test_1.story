Meta:
@TEST_CASE_VERSION: V7
@TEST_CASE_NAME: GG Demo Test 1
@TEST_CASE_DESCRIPTION: As an operator monitoring another operator position and an active conferenceI want to add to the conference the monitored positionSo I can verify that the monitored position can be part of the conference
@TEST_CASE_PRECONDITION: Active role on position 1 has indicate incoming position monitoring calls enabled. Active role on position 3 has indicate incoming position monitoring calls disabled
@TEST_CASE_PASS_FAIL_CRITERIA: Monitoring call and conference are working as expected
@TEST_CASE_DEVICES_IN_USE: 
@TEST_CASE_ID: PVCSX-TC-11472
@TEST_CASE_GLOBAL_ID: GID-5054492
@TEST_CASE_API_ID: 16400504

Scenario: Booking profiles
Given booked profiles:
| profile | group | host           | identifier |
| javafx  | hmi   | <<CLIENT1_IP>> | HMI OP1    |
| javafx  | hmi   | <<CLIENT2_IP>> | HMI OP2    |
| javafx  | hmi   | <<CLIENT3_IP>> | HMI OP3    |

Scenario: Define call queue items
Given the call queue items:
| key          | source                | target           | callType |
| OP1-OP2      | <<OP1_URI>>           | <<OP2_URI>>      | DA/IDA   |
| OP2-OP1      | <<OP2_URI>>           | <<OP1_URI>>      | DA/IDA   |
| OP2-OP1-Conf | <<OP2_URI>>           | <<OP1_URI>>      | CONF     |
| OP1-OP2-Conf | <<OPVOICE1_CONF_URI>> | <<OP2_URI>>      | CONF     |
| OP1-OP3-Conf | <<OPVOICE1_CONF_URI>> | <<OP3_URI>>:5060 | CONF     |

Scenario: Autogenerated Scenario 1
Meta:
@TEST_STEP_ACTION: Op1 makes a monitoring call to Op3
@TEST_STEP_REACTION: Op1 has an indication that its monitoring Op3. Op3 has no indication that it is being monitored
@TEST_STEP_REF: [CATS-REF: KuJ2]
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key MONITORING
When HMI OP1 presses DA key OP3
Then HMI OP1 has the DA key OP3 with visible state monitoringActiveState
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key MONITORING

Scenario: Autogenerated Scenario 2
Meta:
@TEST_STEP_ACTION: Op2 make a DA call to Op1
@TEST_STEP_REACTION: Op1 has an incoming call
@TEST_STEP_REF: [CATS-REF: UHFv]
When HMI OP2 presses DA key OP1
Then HMI OP2 has the DA key OP1 in state out_ringing
Then HMI OP1 has the DA key OP2 in state inc_initiated

Scenario: Autogenerated Scenario 3
Meta:
@TEST_STEP_ACTION: Op1 answers call
@TEST_STEP_REACTION: Call is connected for both operators
@TEST_STEP_REF: [CATS-REF: Gud4]
When HMI OP1 presses DA key OP2
Then HMI OP1 has the call queue item OP2-OP1 in state connected
Then HMI OP2 has the call queue item OP1-OP2 in state connected

Scenario: Autogenerated Scenario 4
Meta:
@TEST_STEP_ACTION: Op1 creates a conference using the active call
@TEST_STEP_REACTION: Conference is created and has 2 participants
@TEST_STEP_REF: [CATS-REF: OZ9L]
When HMI OP1 starts a conference using an existing active call
And waiting for 1 second
Then HMI OP1 has the call queue item OP2-OP1-Conf in state connected
Then HMI OP1 has the call queue item OP2-OP1-Conf in the active list with name label CONF
Then HMI OP1 has the call queue item OP2-OP1-Conf in the active list with info label 2 participants
Then HMI OP1 has a notification that shows Conference call active
Then HMI OP2 has the call queue item OP1-OP2-Conf in state connected
Then HMI OP2 has the call queue item OP1-OP2-Conf in the active list with name label CONF

Scenario: Autogenerated Scenario 5
Meta:
@TEST_STEP_ACTION: Op1 invites Op3 in the conference
@TEST_STEP_REACTION: Op1 sees that Op3 is added to the conference. Op3 receives a conference call
@TEST_STEP_REF: [CATS-REF: EUBN]
When HMI OP1 presses DA key OP3
Then HMI OP1 has the call queue item OP2-OP1-Conf in state connected
Then HMI OP1 has the call queue item OP2-OP1-Conf in the active list with name label CONF
Then HMI OP1 has the call queue item OP2-OP1-Conf in the active list with info label 3 participants
Then HMI OP1 has a notification that shows Conference call active
Then HMI OP3 has the call queue item OP1-OP3-Conf in state inc_initiated

Scenario: Autogenerated Scenario 6
Meta:
@TEST_STEP_ACTION: Op1 verifies monitoring call list
@TEST_STEP_REACTION: Monitoring call list shows Op3 as being monitored
@TEST_STEP_REF: [CATS-REF: X7Ct]
When HMI OP1 with layout <<LAYOUT_MISSION1>> opens monitoring list using function key MONITORING menu
Then HMI OP1 verifies that popup monitoring is visible
Then HMI OP1 verifies that monitoring list contains 1 entries
Then HMI OP1 verifies in the monitoring list that for entry 1 the first column has value ALL
Then HMI OP1 verifies in the monitoring list that for entry 1 the second column has value <<OP3_NAME>>
Then HMI OP1 closes monitoring popup

Scenario: Autogenerated Scenario 7
Meta:
@TEST_STEP_ACTION: Op3 accepts the conference call
@TEST_STEP_REACTION: For Op1 in the conference list  Op3 is shown as as connected
@TEST_STEP_REF: [CATS-REF: qkLI]
Then HMI OP3 accepts the call queue item OP1-OP3-Conf
When HMI OP1 opens the conference participants list
Then HMI OP1 verifies that conference participants list contains 3 participants
Then HMI OP1 verifies in the list that conference participant on position 3 has status connected
Then HMI OP1 verifies in the list that conference participant on position 3 has name <<OP3_NAME>>

Scenario: Autogenerated Scenario 8
Meta:
@TEST_STEP_ACTION: Op1 leaves conference
@TEST_STEP_REACTION: On Op1 monitoring call is still active. Op2 and Op3 are in a call
@TEST_STEP_REF: [CATS-REF: hJOe]
Then HMI OP1 leaves conference
Then HMI OP1 has in the call queue a number of 0 calls
Then HMI OP1 has the DA key OP3 with visible state monitoringActiveState
Then HMI OP3 has in the call queue a number of 1 calls
Then HMI OP2 has in the call queue a number of 1 calls

Scenario: Autogenerated Scenario 9
Meta:
@TEST_STEP_ACTION: Op3 ends active call
@TEST_STEP_REACTION: On Op1 monitoring call is still active. Op2 and Op3 have no calls.
@TEST_STEP_REF: [CATS-REF: aWU5]
Then HMI OP3 terminates the call queue item OP1-OP3-Conf
Then wait for 2 seconds
Then HMI OP3 has in the call queue a number of 0 calls
Then HMI OP2 has in the call queue a number of 0 calls
Then HMI OP1 has the DA key OP3 with visible state monitoringActiveState

Scenario: Autogenerated Scenario 10
Meta:
@TEST_STEP_ACTION: Op1 ends monitoring call
@TEST_STEP_REACTION: Monitoring call is terminated 
@TEST_STEP_REF: [CATS-REF: 81pb]
When HMI OP1 with layout <<LAYOUT_MISSION1>> terminates monitoring calls using function key MONITORING menu
Then HMI OP1 has the DA key OP3 with not visible state monitoringActiveState

Scenario: A scenario that is only executed in case of an execution failure
Meta: @RunOnFailure
GivenStories: voice_GG/ui/includes/@CleanupCollapsedCallQueue.story,			  voice_GG/ui/includes/@CleanupUICallQueueByPosition.story,
			  voice_GG/ui/includes/@CleanupUIMission.story,
			  voice_GG/ui/includes/@CleanupUIFunctionKeys.story
Then waiting until the cleanup is done



