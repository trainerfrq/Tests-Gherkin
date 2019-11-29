Meta:
@TEST_CASE_VERSION: V6
@TEST_CASE_NAME: MaximumCallsOnHold
@TEST_CASE_DESCRIPTION: As an operator having 16 incoming external calls I want to answer and put on hold 5 calls So I can verify that this is the maximum number of allowed calls on hold
@TEST_CASE_PRECONDITION: 
@TEST_CASE_PASS_FAIL_CRITERIA: 
@TEST_CASE_DEVICES_IN_USE: CATS tool is used to simulate 16 external DA calls
@TEST_CASE_ID: PVCSX-TC-11645
@TEST_CASE_GLOBAL_ID: GID-5109366
@TEST_CASE_API_ID: 16975181

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
| key     | source      | target      | callType |
| OP1-OP2 | <<OP1_URI>> | <<OP2_URI>> | DA/IDA   |
| OP2-OP1 | <<OP2_URI>> | <<OP1_URI>> | DA/IDA   |

Scenario: 1. Have 16 external DA calls that call Op1
Meta:
@TEST_STEP_ACTION: Have 16 external DA calls that call Op1
@TEST_STEP_REACTION: Op1 has 16 incoming calls. 3 calls are visible in the waiting list and 13 are in a collapsed area
@TEST_STEP_REF: [CATS-REF: PnZo]
When SipContact calls SIP URI <<OPVOICE1_PHONE_URI>>
Then waiting for 2 seconds

Scenario: 1.1 Op1 verifies the number of incoming calls in the queue
Then HMI OP1 has in the call queue a number of 3 calls
Then HMI OP1 has in the waiting list a number of 3 calls
Then HMI OP1 has in the collapsed area a number of 13 calls

Scenario: 2. Op1 answers one call
Meta:
@TEST_STEP_ACTION: Op1 answers one call
@TEST_STEP_REACTION: In the call queue there are: 1 active call, 3 calls are visible in the waiting call queue list and 12 are in a collapsed area
@TEST_STEP_REF: [CATS-REF: 8q0A]
Then HMI OP1 answers item 1 from waiting call queue list

Scenario: 2.1 Op1 verifies the number of calls in the queue
Then HMI OP1 has in the active list a number of 1 calls
Then HMI OP1 has in the call queue a number of 4 calls
Then HMI OP1 has in the waiting list a number of 3 calls
Then HMI OP1 has in the collapsed area a number of 12 calls

Scenario: 3. Op1 puts active call on hold
Meta:
@TEST_STEP_ACTION: Op1 puts active call on hold
@TEST_STEP_REACTION: In the call queue there are: 0 active call, 1 call on hold, 2 calls are visible in the waiting call queue list and 13 are in a collapsed area
@TEST_STEP_REF: [CATS-REF: vaWn]
When HMI OP1 puts on hold the active call

Scenario: 3.1 Op1 verifies the number of calls in the queue
Then HMI OP1 has in the active list a number of 0 calls
Then HMI OP1 has in the hold list a number of 1 calls
Then HMI OP1 has in the call queue a number of 3 calls
Then HMI OP1 has in the waiting list a number of 2 calls
Then HMI OP1 has in the collapsed area a number of 13 calls

Scenario: 4. Op1 answers one call
Meta:
@TEST_STEP_ACTION: Op1 answers one call
@TEST_STEP_REACTION: In the call queue there are: 1 active call, 1 call on hold, 2 calls are visible in the waiting call queue list and 12 are in a collapsed area
@TEST_STEP_REF: [CATS-REF: bLDS]
Then HMI OP1 answers item 1 from waiting call queue list

Scenario: 4.1 Op1 verifies the number of calls in the queue
Then HMI OP1 has in the active list a number of 1 calls
Then HMI OP1 has in the hold list a number of 1 calls
Then HMI OP1 has in the call queue a number of 4 calls
Then HMI OP1 has in the waiting list a number of 2 calls
Then HMI OP1 has in the collapsed area a number of 12 calls

Scenario: 5. Op1 puts active call on hold
Meta:
@TEST_STEP_ACTION: Op1 puts active call on hold
@TEST_STEP_REACTION: In the call queue there are: 0 active call, 2 calls on hold, 1 call is visible in the waiting call queue list and 13 are in a collapsed area
@TEST_STEP_REF: [CATS-REF: Pfw3]
When HMI OP1 puts on hold the active call

Scenario: 5.1 Op1 verifies the number of calls in the queue
Then HMI OP1 has in the active list a number of 0 calls
Then HMI OP1 has in the hold list a number of 2 calls
Then HMI OP1 has in the call queue a number of 3 calls
Then HMI OP1 has in the waiting list a number of 1 calls
Then HMI OP1 has in the collapsed area a number of 13 calls

Scenario: 6. Op1 answers one call
Meta:
@TEST_STEP_ACTION: Op1 answers one call
@TEST_STEP_REACTION: In the call queue there are: 1 active call, 2 calls on hold, 1 call is visible in the waiting call queue list and 12 are in a collapsed area
@TEST_STEP_REF: [CATS-REF: ZNSQ]
Then HMI OP1 answers item 1 from waiting call queue list

Scenario: 6.1 Op1 verifies the number of calls in the queue
Then HMI OP1 has in the active list a number of 1 calls
Then HMI OP1 has in the hold list a number of 2 calls
Then HMI OP1 has in the call queue a number of 4 calls
Then HMI OP1 has in the waiting list a number of 1 calls
Then HMI OP1 has in the collapsed area a number of 12 calls

Scenario: 7. Op1 puts active call on hold
Meta:
@TEST_STEP_ACTION: Op1 puts active call on hold
@TEST_STEP_REACTION: In the call queue there are: 0 active call, 1 call visible on hold, 2 calls in the hold collapsed area, 1 call is visible in the waiting call queue list and 12 are in a collapsed area
@TEST_STEP_REF: [CATS-REF: CcFj]
When HMI OP1 puts on hold the active call

Scenario: 7.1 Op1 verifies the number of calls in the queue
Then HMI OP1 has in the active list a number of 0 calls
Then HMI OP1 has in the hold list a number of 1 calls
Then HMI OP1 has in the collapsed hold area a number of 2 calls
Then HMI OP1 has in the call queue a number of 2 calls
Then HMI OP1 has in the waiting list a number of 1 calls
Then HMI OP1 has in the collapsed waiting area a number of 12 calls

Scenario: 8. Op1 answers one call
Meta:
@TEST_STEP_ACTION: Op1 answers one call
@TEST_STEP_REACTION: In the call queue there are: 1 active call, 1 call visible on hold, 2 calls in the hold collapsed area, 1 call is visible in the waiting call queue list and 11 are in a collapsed area
@TEST_STEP_REF: [CATS-REF: VFLk]
Then HMI OP1 answers item 1 from waiting call queue list

Scenario: 8.1 Op1 verifies the number of calls in the queue
Then HMI OP1 has in the active list a number of 1 calls
Then HMI OP1 has in the hold list a number of 1 calls
Then HMI OP1 has in the collapsed hold area a number of 2 calls
Then HMI OP1 has in the call queue a number of 3 calls
Then HMI OP1 has in the waiting list a number of 1 calls
Then HMI OP1 has in the collapsed waiting area a number of 11 calls

Scenario: 9. Op1 puts active call on hold
Meta:
@TEST_STEP_ACTION: Op1 puts active call on hold
@TEST_STEP_REACTION: In the call queue there are: 0 active call, 1 call visible on hold, 3 calls in the hold collapsed area, 1 call is visible in the waiting call queue list and 11 are in a collapsed area
@TEST_STEP_REF: [CATS-REF: ZD0b]
When HMI OP1 puts on hold the active call

Scenario: 9.1 Op1 verifies the number of calls in the queue
Then HMI OP1 has in the active list a number of 0 calls
Then HMI OP1 has in the hold list a number of 1 calls
Then HMI OP1 has in the collapsed hold area a number of 3 calls
Then HMI OP1 has in the call queue a number of 2 calls
Then HMI OP1 has in the waiting list a number of 1 calls
Then HMI OP1 has in the collapsed waiting area a number of 11 calls

Scenario: 10. Op1 answers one call
Meta:
@TEST_STEP_ACTION: Op1 answers one call
@TEST_STEP_REACTION: In the call queue there are: 1 active call, 1 call visible on hold, 3 calls in the hold collapsed area, 1 call is visible in the waiting call queue list and 10 are in a collapsed area
@TEST_STEP_REF: [CATS-REF: xKmM]
Then HMI OP1 answers item 1 from waiting call queue list

Scenario: 10.1 Op1 verifies the number of calls in the queue
Then HMI OP1 has in the active list a number of 1 calls
Then HMI OP1 has in the hold list a number of 1 calls
Then HMI OP1 has in the collapsed hold area a number of 3 calls
Then HMI OP1 has in the call queue a number of 3 calls
Then HMI OP1 has in the waiting list a number of 1 calls
Then HMI OP1 has in the collapsed waiting area a number of 10 calls

Scenario: 11. Op1 puts active call on hold
Meta:
@TEST_STEP_ACTION: Op1 puts active call on hold
@TEST_STEP_REACTION: In the call queue there are: 0 active call, 1 call visible on hold, 4 calls in the hold collapsed area, 1 call is visible in the waiting call queue list and 10 are in a collapsed area
@TEST_STEP_REF: [CATS-REF: SY91]
When HMI OP1 puts on hold the active call

Scenario: 11.1 Op1 verifies the number of calls in the queue
Then HMI OP1 has in the active list a number of 0 calls
Then HMI OP1 has in the hold list a number of 1 calls
Then HMI OP1 has in the collapsed hold area a number of 4 calls
Then HMI OP1 has in the call queue a number of 2 calls
Then HMI OP1 has in the waiting list a number of 1 calls
Then HMI OP1 has in the collapsed waiting area a number of 10 calls

Scenario: 12. Op1 answers one call
Meta:
@TEST_STEP_ACTION: Op1 answers one call
@TEST_STEP_REACTION: In the call queue there are: 1 active call, 1 call visible on hold, 4 calls in the hold collapsed area, 1 call is visible in the waiting call queue list and 9 are in a collapsed area
@TEST_STEP_REF: [CATS-REF: GwKB]
Then HMI OP1 answers item 1 from waiting call queue list

Scenario: 12.1 Op1 verifies the number of calls in the queue
Then HMI OP1 has in the active list a number of 1 calls
Then HMI OP1 has in the hold list a number of 1 calls
Then HMI OP1 has in the collapsed hold area a number of 4 calls
Then HMI OP1 has in the call queue a number of 3 calls
Then HMI OP1 has in the waiting list a number of 1 calls
Then HMI OP1 has in the collapsed waiting area a number of 9 calls

Scenario: 13. Op1 puts active call on hold
Meta:
@TEST_STEP_ACTION: Op1 puts active call on hold
@TEST_STEP_REACTION: In the call queue there are: 1 active call, 1 call visible on hold, 4 calls in the hold collapsed area, 1 call is visible in the waiting call queue list and 9 are in a collapsed area
@TEST_STEP_REF: [CATS-REF: lA9N]
When HMI OP1 puts on hold the active call

Scenario: 13.1 Op1 verifies the number of calls in the queue
Then HMI OP1 has in the active list a number of 1 calls
Then HMI OP1 has in the hold list a number of 1 calls
Then HMI OP1 has in the collapsed hold area a number of 4 calls
Then HMI OP1 has in the call queue a number of 3 calls
Then HMI OP1 has in the waiting list a number of 1 calls
Then HMI OP1 has in the collapsed waiting area a number of 9 calls

Scenario: 14. Op1 terminates active call
Meta:
@TEST_STEP_ACTION: Op1 terminates active call
@TEST_STEP_REACTION: In the call queue there are: 0 active call, 1 call visible on hold, 4 calls in the hold collapsed area, 1 call is visible in the waiting call queue list and 9 are in a collapsed area
@TEST_STEP_REF: [CATS-REF: 6LRb]
Then HMI OP1 terminates item 1 from active call queue list

Scenario: 14.1 Op1 verifies the number of calls in the queue
Then HMI OP1 has in the active list a number of 0 calls
Then HMI OP1 has in the hold list a number of 1 calls
Then HMI OP1 has in the collapsed hold area a number of 4 calls
Then HMI OP1 has in the call queue a number of 2 calls
Then HMI OP1 has in the waiting list a number of 1 calls
Then HMI OP1 has in the collapsed waiting area a number of 9 calls

Scenario: 15. Op1 terminates all the remaining waiting calls
Meta:
@TEST_STEP_ACTION: Op1 terminates all the remaining waiting calls
@TEST_STEP_REACTION: In the call queue there are: 0 active call, 3 call visible on hold, 2 calls in the hold collapsed area
@TEST_STEP_REF: [CATS-REF: 9WFQ]
Then HMI OP1 answers and terminates a number of 10 calls

Scenario: 15.1 Op1 verifies the number of calls in the queue
Then HMI OP1 has in the active list a number of 0 calls
Then HMI OP1 has in the hold list a number of 3 calls
Then HMI OP1 has in the collapsed hold area a number of 2 calls
Then HMI OP1 has in the call queue a number of 3 calls
Then HMI OP1 has in the waiting list a number of 0 calls

Scenario: 16. Op1 retrives from hold one call
Meta:
@TEST_STEP_ACTION: Op1 retrives from hold one call
@TEST_STEP_REACTION: In the call queue there are: 1 active call, 4 call visible on hold
Then HMI OP1 retrives from hold item 1 from hold call queue list

Scenario: 16.1 Op1 verifies the number of calls in the queue
Then HMI OP1 has in the active list a number of 1 calls
Then HMI OP1 has in the hold list a number of 4 calls
Then HMI OP1 has in the collapsed hold area a number of 0 calls
Then HMI OP1 has in the call queue a number of 5 calls
Then HMI OP1 has in the waiting list a number of 0 calls

Scenario: 17. Op1 calls Op2
Meta:
@TEST_STEP_ACTION: Op1 calls Op2
@TEST_STEP_REACTION: The previous active call is terminated automatically and call to Op2 is ringing
@TEST_STEP_REF: [CATS-REF: ExXr]
When HMI OP1 presses DA key OP2
Then HMI OP1 has the DA key OP2 in state out_ringing

Scenario: 17.1 Callee client receives the incoming call
Then HMI OP2 has the DA key OP1 in state inc_initiated
Then HMI OP2 has the call queue item OP1-OP2 in state inc_initiated

Scenario: 18. Op2 answers call
Meta:
@TEST_STEP_ACTION: Op2 answers call
@TEST_STEP_REACTION: Op1 call queue shows: 1 active call, 4 call visible on hold
@TEST_STEP_REF: [CATS-REF: CCWi]
When HMI OP2 presses DA key OP1

Scenario: 18.1 Verify call is connected
Then HMI OP1 has the call queue item OP2-OP1 in state connected
Then HMI OP2 has the call queue item OP1-OP2 in state connected

Scenario: 18.2 Op1 verifies the number of calls in the queue
Then HMI OP1 has in the active list a number of 1 calls
Then HMI OP1 has in the hold list a number of 4 calls

Scenario: 19. Op1 puts call on hold
Meta:
@TEST_STEP_ACTION: Op1 puts call on hold
@TEST_STEP_REACTION: Op1 call queue shows: 0 active call, 3 call visible on hold, 2 calls in the hold collapsed area
@TEST_STEP_REF: [CATS-REF: InGs]
When HMI OP1 puts on hold the active call

Scenario: 19.1 Op1 verifies the number of calls in the queue
Then HMI OP1 has in the active list a number of 0 calls
Then HMI OP1 has in the hold list a number of 3 calls
Then HMI OP1 has in the collapsed hold area a number of 2 calls
Then HMI OP1 has in the call queue a number of 3 calls
Then HMI OP1 has in the waiting list a number of 0 calls

Scenario: 20. External call source terminates all calls
Meta:
@TEST_STEP_ACTION: External call source terminates all calls
@TEST_STEP_REACTION: Op1 call queue shows: 0 active call, 1 call visible on hold
@TEST_STEP_REF: [CATS-REF: hB7o]
When SipContact terminates calls

Scenario: 20.1 Op1 verifies the number of calls in the queue
Then HMI OP1 has in the active list a number of 0 calls
Then HMI OP1 has in the hold list a number of 1 calls
Then HMI OP1 has in the call queue a number of 1 calls
Then HMI OP1 has in the waiting list a number of 0 calls

Scenario: 21. Op1 takes call from hold and terminates call
Meta:
@TEST_STEP_ACTION: Op1 takes call from hold and terminates call
@TEST_STEP_REACTION: Op1 call queue shows: 0 active call
@TEST_STEP_REF: [CATS-REF: BCXp]
Then HMI OP1 retrieves from hold the call queue item OP2-OP1

Scenario: 21.1 Verify call is connected again
Then HMI OP1 has the call queue item OP2-OP1 in state connected
Then HMI OP2 has the call queue item OP1-OP2 in state connected

Scenario: 21.2 Callee clears outgoing call
When HMI OP2 presses DA key OP1

Scenario: 21.3 Verify the number of calls in the queue
Then HMI OP1 has in the active list a number of 0 calls
Then HMI OP2 has in the active list a number of 0 calls

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



