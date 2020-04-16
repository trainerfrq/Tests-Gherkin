Meta: @TEST_CASE_VERSION: V9
@TEST_CASE_NAME: MaximumIncomingCallsAndTransfer
@TEST_CASE_DESCRIPTION: As an operator having 16 incoming external calls I want do a the transfer action So I can verify that transfer action can be done only when there are a maximum of 14 incoming calls
@TEST_CASE_PRECONDITION:
@TEST_CASE_PASS_FAIL_CRITERIA: The test is passed when call transfer is done successfully while there are 14 incoming calls.
@TEST_CASE_DEVICES_IN_USE: CATS tool is used to simulate 16 external DA calls
@TEST_CASE_ID: PVCSX-TC-11649
@TEST_CASE_GLOBAL_ID: GID-5112041
@TEST_CASE_API_ID: 17055740

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
| key     | source      | target      | callType |
| OP1-OP2 | <<OP1_URI>> | <<OP2_URI>> | DA/IDA   |
| OP2-OP1 | <<OP2_URI>> | <<OP1_URI>> | DA/IDA   |
| OP3-OP2 | <<OP3_URI>> | <<OP2_URI>> | DA/IDA   |
| OP2-OP3 | <<OP2_URI>> | <<OP3_URI>> | DA/IDA   |

Scenario: 1. Set up 16 external DA calls that call Op1
Meta: @TEST_STEP_ACTION: Set up 16 external DA calls that call Op1
@TEST_STEP_REACTION: Op1 has 16 incoming calls
@TEST_STEP_REF: [CATS-REF: uKr0]
When SipContact calls SIP URI <<OPVOICE1_PHONE_URI>>
Then waiting for 2 seconds

Scenario: 1.1 Op1 verifies the number of incoming calls in the queue
Then HMI OP1 has in the call queue a number of 3 calls
Then HMI OP1 has in the waiting list a number of 3 calls
Then HMI OP1 has in the collapsed area a number of 13 calls

Scenario: 2. Op1 answers one call
Meta: @TEST_STEP_ACTION: Op1 answers one call
@TEST_STEP_REACTION: Op1 has 1 active call and 15 incoming calls
@TEST_STEP_REF: [CATS-REF: yQra]
Then HMI OP1 answers item 1 from waiting call queue list

Scenario: 2.1 Op1 verifies the number of calls in the queue
Then HMI OP1 has in the active list a number of 1 calls
Then HMI OP1 has in the call queue a number of 4 calls
Then HMI OP1 has in the waiting list a number of 3 calls
Then HMI OP1 has in the collapsed area a number of 12 calls

Scenario: 3. Op1 sets the active call for transfer
Meta: @TEST_STEP_ACTION: Op1 sets the active call for transfer
@TEST_STEP_REACTION: Op1 has one call set for transfer, 0 active calls and 15 incoming calls
@TEST_STEP_REF: [CATS-REF: O4Op]
When HMI OP1 initiates a transfer on the active call

Scenario: 3.1 Op1 verifies the number of calls in the queue
Then HMI OP1 has in the active list a number of 0 calls
Then HMI OP1 has in the hold list a number of 1 calls
Then HMI OP1 has in the call queue a number of 3 calls
Then HMI OP1 has in the waiting list a number of 2 calls
Then HMI OP1 has in the collapsed area a number of 13 calls

Scenario: 4. Op1 tries to answer another calls
Meta: @TEST_STEP_ACTION: Op1 tries to answer another calls
@TEST_STEP_REACTION: Op1 gets a message in The Notification Display bar "Call can not be accepted, TRANSFER mode active"
@TEST_STEP_REF: [CATS-REF: U4Oc]
Then HMI OP1 answers item 1 from waiting call queue list

Scenario: 4.1 Verify answer call is not possible
When HMI OP1 opens Notification Display list
Then HMI OP1 verifies that list State contains text Select Call Transfer target
When HMI OP1 selects tab event from notification display popup
Then HMI OP1 verifies that list Event contains on position 0 text Call can not be accepted, TRANSFER mode active
When HMI OP1 selects tab state from notification display popup

Scenario: 4.2 Close popup window
Then HMI OP1 closes notification popup

Scenario: 5. Op1 tries to initiate consultation calls to Op3
Meta: @TEST_STEP_ACTION: Op1 tries to initiate consultation calls to Op3
@TEST_STEP_REACTION: Op1 is not able to initiate call. Op1 has one call set for transfer, 0 active calls and 15 incoming calls
@TEST_STEP_REF: [CATS-REF: kTPy]
When HMI OP1 presses DA key OP3
Then HMI OP1 has the DA key OP3 in state terminated

Scenario: 5.1 Op1 verifies the number of calls in the queue
Then HMI OP1 has in the active list a number of 0 calls
Then HMI OP1 has in the hold list a number of 1 calls
Then HMI OP1 has in the call queue a number of 3 calls
Then HMI OP1 has in the waiting list a number of 2 calls
Then HMI OP1 has in the collapsed area a number of 13 calls

Scenario: 6. Op1 retrieves call from transfer state and ends call
Meta: @TEST_STEP_ACTION: Op1 retrieves call from transfer state and ends call
@TEST_STEP_REACTION: Op1 has 0 active calls and 15 incoming calls
@TEST_STEP_REF: [CATS-REF: yx2B]
Then HMI OP1 retrieves from hold item 1 from hold call queue list
Then HMI OP1 has in the active list a number of 1 calls

Scenario: 6.1 Op1 terminates call
Then HMI OP1 terminates item 1 from active call queue list

Scenario: 6.2 Op1 verifies the number of calls in the queue
Then HMI OP1 has in the active list a number of 0 calls
Then HMI OP1 has in the hold list a number of 0 calls
Then HMI OP1 has in the call queue a number of 3 calls
Then HMI OP1 has in the waiting list a number of 3 calls
Then HMI OP1 has in the collapsed area a number of 12 calls

Scenario: 7. Op1 answers and terminates another call
Meta: @TEST_STEP_ACTION: Op1 answers and terminates another call
@TEST_STEP_REACTION: Op1 has 0 active calls and 14 incoming calls
@TEST_STEP_REF: [CATS-REF: OVGE]
Then HMI OP1 answers item 1 from waiting call queue list
Then HMI OP1 has in the active list a number of 1 calls

Scenario: 7.1 Op1 terminates call
Then HMI OP1 terminates item 1 from active call queue list

Scenario: 7.2 Op1 verifies the number of calls in the queue
Then HMI OP1 has in the active list a number of 0 calls
Then HMI OP1 has in the hold list a number of 0 calls
Then HMI OP1 has in the call queue a number of 3 calls
Then HMI OP1 has in the waiting list a number of 3 calls
Then HMI OP1 has in the collapsed area a number of 11 calls

Scenario: 8. Op2 calls Op1
Meta: @TEST_STEP_ACTION: Op2 calls Op1
@TEST_STEP_REACTION: Op1 has 0 active calls and 15 incoming calls
@TEST_STEP_REF: [CATS-REF: dzwI]
When HMI OP2 presses DA key OP1
Then HMI OP2 has the DA key OP1 in state out_ringing

Scenario: 8.1 Op1 verifies the number of calls in the queue
Then HMI OP1 has in the active list a number of 0 calls
Then HMI OP1 has in the call queue a number of 3 calls
Then HMI OP1 has in the waiting list a number of 3 calls
Then HMI OP1 has in the collapsed area a number of 12 calls

Scenario: 9. Op1 answers calls
Meta: @TEST_STEP_ACTION: Op1 answers calls
@TEST_STEP_REACTION: Op1 has 1 active call and 14 incoming calls
@TEST_STEP_REF: [CATS-REF: HMfN]
When HMI OP1 presses DA key OP2

Scenario: 9.1 Verify call is connected for both operators
Then HMI OP1 has the call queue item OP2-OP1 in state connected
Then HMI OP2 has the call queue item OP1-OP2 in state connected

Scenario: 9.2 Op1 verifies the number of calls in the queue
Then HMI OP1 has in the active list a number of 1 calls
Then HMI OP1 has in the call queue a number of 4 calls
Then HMI OP1 has in the waiting list a number of 3 calls
Then HMI OP1 has in the collapsed area a number of 11 calls

Scenario: 10. Op1 sets the active call for transfer
Meta: @TEST_STEP_ACTION: Op1 sets the active call for transfer
@TEST_STEP_REACTION: Op1 has 1 call set for transfer, 0 active calls and 14 incoming calls
@TEST_STEP_REF: [CATS-REF: 07zV]
When HMI OP1 initiates a transfer on the active call

Scenario: 10.1 Verify call is put on transfer
Then HMI OP1 has the call queue item OP2-OP1 in the hold list with info label XFR Hold

Scenario: 10.2 Op1 verifies the number of calls in the queue
Then HMI OP1 has in the active list a number of 0 calls
Then HMI OP1 has in the hold list a number of 1 calls
Then HMI OP1 has in the call queue a number of 3 calls
Then HMI OP1 has in the waiting list a number of 2 calls
Then HMI OP1 has in the collapsed area a number of 12 calls

Scenario: Autogenerated Scenario 11
Meta: @TEST_STEP_ACTION: Op1 initiate consultation calls to Op3
@TEST_STEP_REACTION: Op1 has 1 call set for transfer, 1 outgoing call and 14 incoming calls
@TEST_STEP_REF: [CATS-REF: etrv]
When HMI OP1 presses DA key OP3
Then HMI OP1 has the DA key OP3 in state out_ringing

Scenario: 11.1 Transfer target receives incoming call
Then HMI OP3 has the DA key OP1 in state inc_initiated

Scenario: 11.2 Op1 verifies the number of calls in the queue
Then HMI OP1 has in the active list a number of 1 calls
Then HMI OP1 has in the hold list a number of 1 calls
Then HMI OP1 has in the call queue a number of 4 calls
Then HMI OP1 has in the waiting list a number of 2 calls
Then HMI OP1 has in the collapsed area a number of 12 calls

Scenario: 12. Op1 transfers calls to Op3
Meta: @TEST_STEP_ACTION: Op1 transfers calls to Op3
@TEST_STEP_REACTION: Op1 has 14 incoming calls, 0 calls set to transfer, 0 outgoing calls. Op2 has a ringing call and Op3 has call initiated
@TEST_STEP_REF: [CATS-REF: ctxk]
When HMI OP1 presses DA key OP3
Then wait for 2 seconds

Scenario: 12.1 Verify call was transferred
Then HMI OP1 has in the active list a number of 0 calls
Then HMI OP1 has in the call queue a number of 3 calls
Then HMI OP1 has in the waiting list a number of 3 calls
Then HMI OP1 has in the collapsed area a number of 11 calls

Scenario: 12.2 Verify call state for the other 2 operators
Then HMI OP2 has the call queue item OP3-OP2 in state out_ringing
Then HMI OP3 has the call queue item OP2-OP3 in state inc_initiated

Scenario: 13. Op2 ends call
Meta: @TEST_STEP_ACTION: Op2 ends call
@TEST_STEP_REACTION: Op2 and Op3 have no calls in the call queue
@TEST_STEP_REF: [CATS-REF: fAON]
When HMI OP2 presses DA key OP3
Then HMI OP2 has in the call queue a number of 0 calls
Then HMI OP3 has in the call queue a number of 0 calls

Scenario: 14. Op1 answers and terminates the 14 incoming calls
Meta: @TEST_STEP_ACTION: Op1 answers and terminates the 14 incoming calls
@TEST_STEP_REACTION: Op1 has no calls in the call queue
@TEST_STEP_REF: [CATS-REF: jPjg]
Then HMI OP1 answers and terminates a number of 14 calls

Scenario: 14.1  Verify the number of calls in the queue
Then HMI OP1 has in the call queue a number of 0 calls

Scenario: Remove phone
When SipContact is removed

Scenario: A scenario that is only executed in case of an execution failure
Meta: @RunOnFailure
GivenStories: voice_GG/ui/includes/@CleanupStory.story
Then waiting until the cleanup is done