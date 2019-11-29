Meta:
@TEST_CASE_VERSION: V6
@TEST_CASE_NAME: MaximumIncomingCallsAndChangeMission
@TEST_CASE_DESCRIPTION: As an operator having 16 incoming external calls I want to change mission So I can verify that the incoming calls are not affected by the mission active role settings
@TEST_CASE_PRECONDITION: Test starts with Op1 having mission MISSION_1_NAME
						MISSION_1_NAME has an active role that allows 16 incoming calls
						MISSION_2_NAME has an active role that allows 8 incoming calls
@TEST_CASE_PASS_FAIL_CRITERIA: The test is passed when the call limit is applied after changing mission
@TEST_CASE_DEVICES_IN_USE: CATS tool is used to simulate 16 external DA calls
@TEST_CASE_ID: PVCSX-TC-11646
@TEST_CASE_GLOBAL_ID: GID-5111727
@TEST_CASE_API_ID: 17054810

Scenario: Booking profiles
Given booked profiles:
| profile | group          | host           | identifier |
| javafx  | hmi            | <<CLIENT1_IP>> | HMI OP1    |
| javafx  | hmi            | <<CLIENT2_IP>> | HMI OP2    |
| javafx  | hmi            | <<CLIENT3_IP>> | HMI OP3    |
| voip    | <<systemName>> | <<CO3_IP>>     | VOIP       |

Scenario: Create sip phone
Given SipContacts group SipContact:
| key      | profile | user-entity | sip-uri   |
| Caller1  | VOIP    | 1           | <<SIP1>>  |
| Caller2  | VOIP    | 2           | <<SIP2>>  |
| Caller3  | VOIP    | 3           | <<SIP3>>  |
| Caller4  | VOIP    | 4           | <<SIP4>>  |
| Caller5  | VOIP    | 5           | <<SIP5>>  |
| Caller6  | VOIP    | 6           | <<SIP6>>  |
| Caller7  | VOIP    | 7           | <<SIP7>>  |
| Caller8  | VOIP    | 8           | <<SIP8>>  |
| Caller9  | VOIP    | 9           | <<SIP9>>  |
| Caller10 | VOIP    | 10          | <<SIP10>> |
| Caller11 | VOIP    | 11          | <<SIP11>> |
| Caller12 | VOIP    | 12          | <<SIP12>> |
| Caller13 | VOIP    | 13          | <<SIP13>> |
| Caller14 | VOIP    | 14          | <<SIP14>> |
| Caller15 | VOIP    | 15          | <<SIP15>> |
| Caller16 | VOIP    | 16          | <<SIP16>> |

Given phones for SipContact are created

Scenario: 1. Have 16 external DA calls that call Op1
Meta:
@TEST_STEP_ACTION: Have 16 external DA calls that call Op1
@TEST_STEP_REACTION: Op1 has 16 incoming calls
@TEST_STEP_REF: [CATS-REF: 3c4d]
When SipContact calls SIP URI <<OPVOICE1_PHONE_URI>>
Then waiting for 2 seconds

Scenario: 1.2 Op1 verifies the number of incoming calls in the queue
Then HMI OP1 has in the call queue a number of 3 calls
Then HMI OP1 has in the waiting list a number of 3 calls
Then HMI OP1 has in the collapsed area a number of 13 calls

Scenario: 2. Op1 changes mission to MISSION_2_NAME
Meta:
@TEST_STEP_ACTION: Op1 changes mission to MISSION_2_NAME;
@TEST_STEP_REACTION: Op1 active mission is MISSION_2_NAME;
@TEST_STEP_REF: [CATS-REF: yib2]
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key MISSIONS
Then HMI OP1 changes current mission to mission <<MISSION_2_NAME>>
Then HMI OP1 activates mission
Then waiting for 5 seconds

Scenario: 2.1 Verify operator mission
Then HMI OP1 has in the DISPLAY STATUS section mission the assigned mission <<MISSION_2_NAME>>

Scenario: 3. Op1 verifies the number of incoming calls in the queue
Meta:
@TEST_STEP_ACTION: Op1 verifies the number of incoming calls in the queue
@TEST_STEP_REACTION: Op1 has 16 incoming calls
@TEST_STEP_REF: [CATS-REF: W1cM]
Then HMI OP1 has in the call queue a number of 3 calls
Then HMI OP1 has in the waiting list a number of 3 calls
Then HMI OP1 has in the collapsed area a number of 13 calls

Scenario: 4. Op1 answers and terminates 8 of the incoming calls
Meta:
@TEST_STEP_ACTION: Op1 answers and terminates 8 of the incoming calls
@TEST_STEP_REACTION: Op1 has 8 incoming calls
@TEST_STEP_REF: [CATS-REF: JGVl]
Then HMI OP1 answers and terminates a number of 8 calls

Scenario: Op1 verifies the number of calls in the queue
Then HMI OP1 has in the active list a number of 0 calls
Then HMI OP1 has in the call queue a number of 3 calls
Then HMI OP1 has in the waiting list a number of 3 calls
Then HMI OP1 has in the collapsed area a number of 5 calls

Scenario: 5. Op3 tries to establishes an outgoing call to Op1
Meta:
@TEST_STEP_ACTION: Op3 tries to establishes an outgoing call to Op1
@TEST_STEP_REACTION: Op3 is not able to call Op1
@TEST_STEP_REF: [CATS-REF: Qt2a]
When HMI OP3 presses DA key OP1
Then HMI OP3 has the DA key OP1 in state out_failed

Scenario: 5.1 Op1 verifies the number of calls in the queue
Then HMI OP1 has in the active list a number of 0 calls
Then HMI OP1 has in the call queue a number of 3 calls
Then HMI OP1 has in the waiting list a number of 3 calls
Then HMI OP1 has in the collapsed area a number of 5 calls

Scenario: 6. Op1 changes mission to MISSION_1_NAME
Meta:
@TEST_STEP_ACTION: Op1 changes mission to MISSION_1_NAME;
@TEST_STEP_REACTION: Op1 active mission is MISSION_1_NAME. Op1 has 8 incoming calls
@TEST_STEP_REF: [CATS-REF: hl0r]
When HMI OP1 with layout <<LAYOUT_MISSION2>> presses function key MISSIONS
Then HMI OP1 changes current mission to mission <<MISSION_1_NAME>>
Then HMI OP1 activates mission
Then waiting for 5 seconds

Scenario: 6.1 Verify operator mission
Then HMI OP1 has in the DISPLAY STATUS section mission the assigned mission <<MISSION_1_NAME>>

Scenario: 6.2 Op1 verifies the number of calls in the queue
Then HMI OP1 has in the active list a number of 0 calls
Then HMI OP1 has in the call queue a number of 3 calls
Then HMI OP1 has in the waiting list a number of 3 calls
Then HMI OP1 has in the collapsed area a number of 5 calls

Scenario: 7. Op3 tries to establishes an outgoing call to Op1
Meta:
@TEST_STEP_ACTION: Op3 tries to establishes an outgoing call to Op1
@TEST_STEP_REACTION: Op3 has a ringing call. Op1 has one more call in the call queue
@TEST_STEP_REF: [CATS-REF: 5rW1]
When HMI OP3 presses DA key OP1
Then HMI OP3 has the DA key OP1 in state out_ringing

Scenario: 7.1 Op1 client receives the incoming call
Then HMI OP1 has the DA key OP3 in state inc_initiated

Scenario: 7.2 Op1 verifies the number of calls in the queue
Then HMI OP1 has in the active list a number of 0 calls
Then HMI OP1 has in the call queue a number of 3 calls
Then HMI OP1 has in the waiting list a number of 3 calls
Then HMI OP1 has in the collapsed area a number of 6 calls

Scenario: 8. Op1 answers and terminates 8 of the incoming calls
Meta:
@TEST_STEP_ACTION: Op1 answers and terminates 9 of the incoming calls
@TEST_STEP_REACTION: Op1 has 0 calls in the call queue
@TEST_STEP_REF: [CATS-REF: u5eF]
Then HMI OP1 answers and terminates a number of 9 calls

Scenario: 8.1 Verify the number of calls in the queue
Then HMI OP1 has in the active list a number of 0 calls

Scenario: Remove phone
When SipContact is removed

Scenario: A scenario that is only executed in case of an execution failure
Meta: @RunOnFailure
GivenStories: voice_GG/ui/includes/@CleanupCollapsedCallQueue.story,
			  voice_GG/ui/includes/@CleanupUICallQueueByPosition.story,
			  voice_GG/ui/includes/@CleanupUIMission.story,
			  voice_GG/ui/includes/@CleanupUIFunctionKeys.story,
			  voice_GG/ui/includes/@CleanupUIWindows.story
Then waiting for 1 millisecond



