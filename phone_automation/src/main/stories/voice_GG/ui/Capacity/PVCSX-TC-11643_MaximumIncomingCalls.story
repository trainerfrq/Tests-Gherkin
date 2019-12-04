Meta:
@TEST_CASE_VERSION: V6
@TEST_CASE_NAME: MaximumIncomingCalls
@TEST_CASE_DESCRIPTION: As an operator having 16 incoming external calls and another operator attempts to call my position I want to verify that the operator will not be able to call my position only after one of the waiting calls is terminated
@TEST_CASE_PRECONDITION:
@TEST_CASE_PASS_FAIL_CRITERIA: The test is passed when all 16 calls are visible on the operator position and no other call can be made to that position, until one of the 16 calls is terminated
@TEST_CASE_DEVICES_IN_USE: CATS tool is used to simulate 16 external DA calls
@TEST_CASE_ID: PVCSX-TC-11643
@TEST_CASE_GLOBAL_ID: GID-5106937
@TEST_CASE_API_ID: 16956406

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

Scenario: Define call queue items
Given the call queue items:
| key         | source      | target                 | callType |
| OP1-OP2     | <<OP1_URI>> | <<OP2_URI>>            | IA       |
| OP2-OP1     | <<OP2_URI>> | <<OP1_URI>>            | IA       |

Scenario: 1. Have 16 external DA calls that call Op1
Meta:
@TEST_STEP_ACTION: Have 16 external DA calls that call Op1
@TEST_STEP_REACTION: Op1 has 16 incoming calls
@TEST_STEP_REF: [CATS-REF: 2WMl]
When SipContact calls SIP URI <<OPVOICE1_PHONE_URI>>
Then waiting for 2 seconds

Scenario: 1.1 Op1 verifies the number of incoming calls in the queue
Then HMI OP1 has in the call queue a number of 3 calls
Then HMI OP1 has in the waiting list a number of 3 calls
Then HMI OP1 has in the collapsed area a number of 13 calls

Scenario: 2. Op2 attempts to do an IA call to Op1
Meta:
@TEST_STEP_ACTION: Op2 attempts to do an IA call to Op1
@TEST_STEP_REACTION: Op2 attempt to call fails
@TEST_STEP_REF: [CATS-REF: gK2M]
When HMI OP2 with layout <<LAYOUT_MISSION2>> selects grid tab 2
When HMI OP2 presses IA key IA - OP1

Scenario: 2.1 Op2 has a failed call in the call queue
Then HMI OP2 has in the call queue a number of 1 calls
Then HMI OP2 has the IA key IA - OP2 in state terminated

Scenario: 2.2 Op2 terminates failed call
When HMI OP2 presses IA key IA - OP1

Scenario: 3. Op1 answers one call and verifies the call queue
Meta:
@TEST_STEP_ACTION: Op1 answers one call and verifies the call queue
@TEST_STEP_REACTION: The call queue has 1 active call, 3 calls visible in the waiting call queue and 12 waiting calls collapsed
@TEST_STEP_REF: [CATS-REF: jUBb]
Then HMI OP1 answers item 1 from waiting call queue list

Scenario: 3.1 Op1 verifies the number of calls in the queue
Then HMI OP1 has in the active list a number of 1 calls
Then HMI OP1 has in the call queue a number of 4 calls
Then HMI OP1 has in the waiting list a number of 3 calls
Then HMI OP1 has in the collapsed area a number of 12 calls

Scenario: 4. Op1 terminates call and verifies queue
Meta:
@TEST_STEP_ACTION: Op1 terminates call and verifies queue
@TEST_STEP_REACTION: The call queue has 0 active call, 3 calls visible in the waiting call queue and 12 waiting calls collapsed
@TEST_STEP_REF: [CATS-REF: 4NP6]
Then HMI OP1 terminates item 1 from active call queue list

Scenario: 4.1 Op1 verifies the number of calls in the queue
Then HMI OP1 has in the active list a number of 0 calls
Then HMI OP1 has in the call queue a number of 3 calls
Then HMI OP1 has in the waiting list a number of 3 calls
Then HMI OP1 has in the collapsed area a number of 12 calls

Scenario: 5. Op2 attempts to do an IA call to Op1
Meta:
@TEST_STEP_ACTION: Op2 attempts to do an IA call to Op1
@TEST_STEP_REACTION: IA call is done succesfully
@TEST_STEP_REF: [CATS-REF: 1yKl]
When HMI OP2 presses IA key IA - OP1
Then HMI OP1 has the call queue item OP2-OP1 in state connected
Then HMI OP1 has the IA key IA - OP2 in state connected

Scenario: 6. Op1 answers the IA call
Meta:
@TEST_STEP_ACTION: Op1 answers the IA call
@TEST_STEP_REACTION: Op1 and Op2 have an IA duplex call
@TEST_STEP_REF: [CATS-REF: juJb]
When HMI OP1 with layout <<LAYOUT_MISSION1>> selects grid tab 2
When HMI OP1 presses IA key IA - OP2

Scenario: 6.1 Verify call direction
Then HMI OP1 has the IA call queue item OP2-OP1 with audio direction duplex
Then HMI OP2 has the IA call queue item OP1-OP2 with audio direction duplex

Scenario: 6.2 Op1 verifies the number of calls in the queue
Then HMI OP1 has in the active list a number of 1 calls
Then HMI OP1 has in the call queue a number of 4 calls
Then HMI OP1 has in the waiting list a number of 3 calls
Then HMI OP1 has in the collapsed area a number of 12 calls

Scenario: 7. Op1 terminates IA call
Meta:
@TEST_STEP_ACTION: Op1 terminates IA call
@TEST_STEP_REACTION: IA call changes from a full duplex to a half duplex call
@TEST_STEP_REF: [CATS-REF: v7MY]
When HMI OP1 presses IA key IA - OP2

Scenario: 7.1 Verify call direction
Then HMI OP1 has the IA call queue item OP2-OP1 with audio direction rx_monitored
Then HMI OP2 has the IA call queue item OP1-OP2 with audio direction tx_monitored

Scenario: 8. Op2 terminates IA call
Meta:
@TEST_STEP_ACTION: Op2 terminates IA call
@TEST_STEP_REACTION: IA call is terminated
@TEST_STEP_REF: [CATS-REF: Ji1W]
When HMI OP2 presses IA key IA - OP1

Scenario: 8.1 Call is terminated also for both operators
Then HMI OP2 has in the call queue a number of 0 calls
Then HMI OP1 has in the active list a number of 0 calls

Scenario: 9. All external calls are terminated by Op1
Meta:
@TEST_STEP_ACTION: All external calls are terminated by Op1
@TEST_STEP_REACTION: Op1 has 0 calls in the queue
@TEST_STEP_REF: [CATS-REF: CmEE]
GivenStories: voice_GG/ui/includes/@CleanupCollapsedCallQueue.story,
			  voice_GG/ui/includes/@CleanupUICallQueueByPosition.story
Then HMI OP1 has in the call queue a number of 0 calls

Scenario: Remove phone
When SipContact is removed

Scenario: Cleanup - always select first tab
When HMI OP2 with layout <<LAYOUT_MISSION2>> selects grid tab 1
When HMI OP1 with layout <<LAYOUT_MISSION1>> selects grid tab 1

Scenario: A scenario that is only executed in case of an execution failure
Meta: @RunOnFailure
GivenStories: voice_GG/ui/includes/@CleanupCollapsedCallQueue.story,
			  voice_GG/ui/includes/@CleanupUICallQueueByPosition.story,
			  voice_GG/ui/includes/@CleanupUIMission.story,
			  voice_GG/ui/includes/@CleanupUIFunctionKeys.story
Then waiting for 1 millisecond


