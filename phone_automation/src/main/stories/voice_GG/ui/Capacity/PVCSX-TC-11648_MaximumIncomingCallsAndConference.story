Meta: @TEST_CASE_VERSION: V8
@TEST_CASE_NAME: MaximumIncomingCallsAndConference
@TEST_CASE_DESCRIPTION: As an operator having an active conference with 2 participants I want to receive 16 incoming external calls So I can verify that only 15 of them will be visible on the operator position
@TEST_CASE_PRECONDITION:
@TEST_CASE_PASS_FAIL_CRITERIA: The test is passed when the operator has 1 active conference call and 15 incoming calls
@TEST_CASE_DEVICES_IN_USE: CATS tool is used to simulate 16 external DA calls
@TEST_CASE_ID: PVCSX-TC-11648
@TEST_CASE_GLOBAL_ID: GID-5112026
@TEST_CASE_API_ID: 17055692

Scenario: Booking profiles
Given booked profiles:
| profile             | group          | host           | identifier |
| javafx              | hmi            | <<CLIENT1_IP>> | HMI OP1    |
| javafx              | hmi            | <<CLIENT2_IP>> | HMI OP2    |
| javafx              | hmi            | <<CLIENT3_IP>> | HMI OP3    |
| voip/<<systemName>> | <<systemName>> | <<CO3_IP>>     | VOIP       |

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
| key          | source                | target           | callType |
| OP2-OP1-Conf | <<OP2_URI>>           | <<OP1_URI>>      | CONF     |
| OP1-OP2      | <<OP1_URI>>           | <<OP2_URI>>      | DA/IDA   |
| OP2-OP1      | <<OP2_URI>>           | <<OP1_URI>>      | DA/IDA   |
| OP1-OP3-Conf | <<OPVOICE1_CONF_URI>> | <<OP3_URI>>:5060 | CONF     |

Scenario: 1. Op2 calls Op1
Meta: @TEST_STEP_ACTION: Op2 calls Op1
@TEST_STEP_REACTION: Op1 answers the call
@TEST_STEP_REF: [CATS-REF: X25n]
When HMI OP2 presses DA key OP1
Then HMI OP2 has the DA key OP1 in state out_ringing

Scenario: 1.1 Op1 client receives the incoming call and answers the call
Then HMI OP1 has the DA key OP2 in state inc_initiated
When HMI OP1 presses DA key OP2

Scenario: 1.2 Verify call is connected for both operators
Then HMI OP1 has the call queue item OP2-OP1 in state connected
Then HMI OP2 has the call queue item OP1-OP2 in state connected

Scenario: 2. Op1 starts a conference using the existing active call
		  @TEST_STEP_ACTION: Op1 starts a conference using the existing active call
		  @TEST_STEP_REACTION: Op1 has a conference with 2 participants
		  @TEST_STEP_REF: [CATS-REF: 30wW]
When HMI OP1 starts a conference using an existing active call
And waiting for 1 second
Then HMI OP1 has the call queue item OP2-OP1-Conf in state connected
Then HMI OP1 has the call queue item OP2-OP1-Conf in the active list with name label CONF
Then HMI OP1 has the call queue item OP2-OP1-Conf in the active list with info label 2 participants

Scenario: 3. Op1 invites Op3 to the conference
Meta: @TEST_STEP_ACTION: Op1 invites Op3 to the conference.
@TEST_STEP_REACTION: Op3 receives conference call.
@TEST_STEP_REF: [CATS-REF: HOhu]
When HMI OP1 presses DA key OP3

Scenario: 3.1 Op3 client receives the incoming call and answers the call
Then HMI OP3 has the call queue item OP1-OP3-Conf in state inc_initiated

Scenario: 4. Op3 answers conference call
Meta: @TEST_STEP_ACTION: Op3 answers conference call
@TEST_STEP_REACTION: Op1 has a n active conference with 3 participants
@TEST_STEP_REF: [CATS-REF: tpWe]
Then HMI OP3 accepts the call queue item OP1-OP3-Conf

Scenario: 4.1 Op1 verifies conference state
Then HMI OP1 has the call queue item OP2-OP1-Conf in state connected
Then HMI OP1 has the call queue item OP2-OP1-Conf in the active list with name label CONF
Then HMI OP1 has the call queue item OP2-OP1-Conf in the active list with info label 3 participants

Scenario: 5. Have 16 external DA calls that call Op1
Meta: @TEST_STEP_ACTION: Have 16 external DA calls that call Op1
@TEST_STEP_REACTION: Op1 has 15 incoming calls and 1 active conference call
@TEST_STEP_REF: [CATS-REF: rAOg]
When SipContact calls SIP URI <<OPVOICE1_PHONE_URI>>
Then waiting for 2 seconds

Scenario: 5.1 Op1 verifies the number of calls in the queue
Then HMI OP1 has in the active list a number of 1 calls
Then HMI OP1 has in the call queue a number of 4 calls
Then HMI OP1 has in the waiting list a number of 3 calls
Then HMI OP1 has in the collapsed area a number of 12 calls

Scenario: 6. Op1 leaves conference
Meta: @TEST_STEP_ACTION: Op1 leaves conference
@TEST_STEP_REACTION: Op1 has 15 incoming calls and 0 active calls
@TEST_STEP_REF: [CATS-REF: z74m]
Then HMI OP1 terminates the call queue item OP2-OP1-Conf

Scenario: 6.1 Op1 verifies the number of incoming calls in the queue
Then HMI OP1 has in the active list a number of 0 calls
Then HMI OP1 has in the call queue a number of 3 calls
Then HMI OP1 has in the waiting list a number of 3 calls
Then HMI OP1 has in the collapsed area a number of 12 calls

Scenario: 7. Op2 calls Op1
Meta: @TEST_STEP_ACTION: Op2 calls Op1
@TEST_STEP_REACTION: Op1 answers the call
@TEST_STEP_REF: [CATS-REF: QCGZ]
When HMI OP2 presses DA key OP1
Then HMI OP2 has the DA key OP1 in state out_ringing

Scenario: 7.1 Op1 client receives the incoming call and answers the call
Then HMI OP1 has the DA key OP2 in state inc_initiated
When HMI OP1 presses DA key OP2

Scenario: 7.2 Verify call is connected for both operators
Then HMI OP1 has the call queue item OP2-OP1 in state connected
Then HMI OP2 has the call queue item OP1-OP2 in state connected

Scenario: 8. Op1 tries to start a new conference using the existing active call
Meta: @TEST_STEP_ACTION: Op1 starts a conference using the existing active call
@TEST_STEP_REACTION: Conference (indicated with 0 participants on the call queue) can't be created due to lack of resources. Op1 has 1 call on hold, 15 incoming calls
@TEST_STEP_REF: [CATS-REF: axKc]
When HMI OP1 starts a conference using an existing active call
And waiting for 1 second
Then HMI OP1 has the call queue item OP2-OP1-Conf in state connected
Then HMI OP1 has the call queue item OP2-OP1-Conf in the active list with name label CONF
Then HMI OP1 has the call queue item OP2-OP1-Conf in the active list with info label 0 participants

Scenario: 8.1 Op1 verifies the number calls in the queue
Then HMI OP1 has in the active list a number of 1 calls
Then HMI OP1 has in the call queue a number of 4 calls
Then HMI OP1 has in the waiting list a number of 2 calls
Then HMI OP1 has in the hold list a number of 1 calls
Then HMI OP1 has in the collapsed area a number of 13 calls

Scenario: 9. Op1 terminates conference call
Meta: @TEST_STEP_ACTION: Op1 terminates conference call
@TEST_STEP_REACTION: Op1 has 16 incoming calls and 0 active calls
@TEST_STEP_REF: [CATS-REF: Mx0X]
Then HMI OP1 terminates the call queue item OP2-OP1-Conf

Scenario: 9.1 Op1 verifies the number of calls in the queue
Then HMI OP1 has in the active list a number of 0 calls
Then HMI OP1 has in the call queue a number of 3 calls
Then HMI OP1 has in the waiting list a number of 2 calls
Then HMI OP1 has in the hold list a number of 1 calls
Then HMI OP1 has in the collapsed area a number of 13 calls

Scenario: 10. Op1 terminates all 16 incoming calls
Meta: @TEST_STEP_ACTION: Op1 terminates all 16 incoming calls
@TEST_STEP_REACTION: Op1 has no calls in the call queue
@TEST_STEP_REF: [CATS-REF: MR4B]
Then HMI OP1 retrives from hold item 1 from hold call queue list
Then HMI OP1 terminates item 1 from active call queue list
Then HMI OP1 answers and terminates a number of 15 calls
Then HMI OP1 has in the call queue a number of 0 calls

Scenario: Remove phone
When SipContact is removed

Scenario: A scenario that is only executed in case of an execution failure
Meta: @RunOnFailure
GivenStories: voice_GG/ui/includes/@CleanupStory.story
Then waiting until the cleanup is done
