Meta:
@TEST_CASE_VERSION: V3
@TEST_CASE_NAME: MaximumIncomingCallsAnswered
@TEST_CASE_DESCRIPTION: narrative:As an operator having 16 incoming external calls I want to answer each of the incoming call So I can verify that the call queue is adapted accordingly with my actions
@TEST_CASE_PRECONDITION:
@TEST_CASE_PASS_FAIL_CRITERIA: The test is passed when each call is answered and call queue is updated with each answer action
@TEST_CASE_DEVICES_IN_USE: CATS tool is used to simulate 16 external calls
@TEST_CASE_ID: PVCSX-TC-11644
@TEST_CASE_GLOBAL_ID: GID-5109361
@TEST_CASE_API_ID: 16974420

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

Scenario: 1. Have 16 external calls that call Op1
Meta:
@TEST_STEP_ACTION: Have 16 external calls that call Op1
@TEST_STEP_REACTION: Op1 has 16 incoming calls. 3 calls are visible in the waiting list and 13 are in a collapsed area
@TEST_STEP_REF: [CATS-REF: phco]
When SipContact calls SIP URI <<OPVOICE1_PHONE_URI>>
Then waiting for 2 seconds

Scenario: 1.1 Op1 verifies the number of incoming calls in the queue
Then HMI OP1 has in the call queue a number of 3 calls
Then HMI OP1 has in the waiting list a number of 3 calls
Then HMI OP1 has in the collapsed area a number of 13 calls

Scenario: 2. Op1 answers one calls
Meta:
@TEST_STEP_ACTION: Op1 answers one calls
@TEST_STEP_REACTION: In the call queue there are: 1 active call, 3 calls are visible in the waiting call queue list and 12 are in a collapsed area
@TEST_STEP_REF: [CATS-REF: aGUm]
Then HMI OP1 answers item 1 from waiting call queue list

Scenario: 2.1 Op1 verifies the number of calls in the queue
Then HMI OP1 has in the active list a number of 1 calls
Then HMI OP1 has in the call queue a number of 4 calls
Then HMI OP1 has in the waiting list a number of 3 calls
Then HMI OP1 has in the collapsed area a number of 12 calls

Scenario: 3. Op1 terminates active call
Meta:
@TEST_STEP_ACTION: Op1 terminates active call 
@TEST_STEP_REACTION: In the call queue there are: 0 active call, 3 calls are visible in the waiting call queue list and 12 are in a collapsed area
@TEST_STEP_REF: [CATS-REF: NFCi]
Then HMI OP1 terminates item 1 from active call queue list

Scenario: 3.1 Op1 verifies the number of calls in the queue
Then HMI OP1 has in the active list a number of 0 calls
Then HMI OP1 has in the call queue a number of 3 calls
Then HMI OP1 has in the waiting list a number of 3 calls
Then HMI OP1 has in the collapsed area a number of 12 calls

Scenario: 4. Answering and terminate calls actions are repeated for the next 10 calls
Meta:
@TEST_STEP_ACTION: Answering and terminate calls actions are repeated for the next 10 calls
@TEST_STEP_REACTION: The call queue will be adapted accordingly: active call visible when answered, not visible when terminated, 3 calls visible in the waiting call queue list and calls shown in the collapsed area is decreasing by one with every answered call
@TEST_STEP_REF: [CATS-REF: yjsJ]
Scenario: 4.1 Op1 answers one call
Then HMI OP1 answers item 1 from waiting call queue list

Scenario: 4.2 Op1 verifies the number of calls in the queue
Then HMI OP1 has in the active list a number of 1 calls
Then HMI OP1 has in the call queue a number of 4 calls
Then HMI OP1 has in the waiting list a number of 3 calls
Then HMI OP1 has in the collapsed area a number of 11 calls

Scenario: 4.3 Op1 terminates active call
Then HMI OP1 terminates item 1 from active call queue list

Scenario: 4.4 Op1 verifies the number of calls in the queue
Then HMI OP1 has in the active list a number of 0 calls
Then HMI OP1 has in the call queue a number of 3 calls
Then HMI OP1 has in the waiting list a number of 3 calls
Then HMI OP1 has in the collapsed area a number of 11 calls

Scenario: 4.5 Op1 answers one call
Then HMI OP1 answers item 1 from waiting call queue list

Scenario: 4.6 Op1 verifies the number of calls in the queue
Then HMI OP1 has in the active list a number of 1 calls
Then HMI OP1 has in the call queue a number of 4 calls
Then HMI OP1 has in the waiting list a number of 3 calls
Then HMI OP1 has in the collapsed area a number of 10 calls

Scenario: 4.7 Op1 terminates active call
Then HMI OP1 terminates item 1 from active call queue list

Scenario: 4.8 Op1 verifies the number of calls in the queue
Then HMI OP1 has in the active list a number of 0 calls
Then HMI OP1 has in the call queue a number of 3 calls
Then HMI OP1 has in the waiting list a number of 3 calls
Then HMI OP1 has in the collapsed area a number of 10 calls

Scenario: 4.9 Op1 answers one call
Then HMI OP1 answers item 1 from waiting call queue list

Scenario: 4.10 Op1 verifies the number of calls in the queue
Then HMI OP1 has in the active list a number of 1 calls
Then HMI OP1 has in the call queue a number of 4 calls
Then HMI OP1 has in the waiting list a number of 3 calls
Then HMI OP1 has in the collapsed area a number of 9 calls

Scenario: 4.11 Op1 terminates active call
Then HMI OP1 terminates item 1 from active call queue list

Scenario: 4.12 Op1 verifies the number of calls in the queue
Then HMI OP1 has in the active list a number of 0 calls
Then HMI OP1 has in the call queue a number of 3 calls
Then HMI OP1 has in the waiting list a number of 3 calls
Then HMI OP1 has in the collapsed area a number of 9 calls

Scenario: 4.13 Op1 answers one call
Then HMI OP1 answers item 1 from waiting call queue list

Scenario: 4.14 Op1 verifies the number of calls in the queue
Then HMI OP1 has in the active list a number of 1 calls
Then HMI OP1 has in the call queue a number of 4 calls
Then HMI OP1 has in the waiting list a number of 3 calls
Then HMI OP1 has in the collapsed area a number of 8 calls

Scenario: 4.15 Op1 terminates active call
Then HMI OP1 terminates item 1 from active call queue list

Scenario: 4.16 Op1 verifies the number of calls in the queue
Then HMI OP1 has in the active list a number of 0 calls
Then HMI OP1 has in the call queue a number of 3 calls
Then HMI OP1 has in the waiting list a number of 3 calls
Then HMI OP1 has in the collapsed area a number of 8 calls

Scenario: 4.17 Op1 answers one call
Then HMI OP1 answers item 1 from waiting call queue list

Scenario: 4.18 Op1 verifies the number of calls in the queue
Then HMI OP1 has in the active list a number of 1 calls
Then HMI OP1 has in the call queue a number of 4 calls
Then HMI OP1 has in the waiting list a number of 3 calls
Then HMI OP1 has in the collapsed area a number of 7 calls

Scenario: 4.19 Op1 terminates active call
Then HMI OP1 terminates item 1 from active call queue list

Scenario: 4.20 Op1 verifies the number of calls in the queue
Then HMI OP1 has in the active list a number of 0 calls
Then HMI OP1 has in the call queue a number of 3 calls
Then HMI OP1 has in the waiting list a number of 3 calls
Then HMI OP1 has in the collapsed area a number of 7 calls

Scenario: 4.21 Op1 answers one call
Then HMI OP1 answers item 1 from waiting call queue list

Scenario: 4.22 Op1 verifies the number of calls in the queue
Then HMI OP1 has in the active list a number of 1 calls
Then HMI OP1 has in the call queue a number of 4 calls
Then HMI OP1 has in the waiting list a number of 3 calls
Then HMI OP1 has in the collapsed area a number of 6 calls

Scenario: 4.23 Op1 terminates active call
Then HMI OP1 terminates item 1 from active call queue list

Scenario: 4.24 Op1 verifies the number of calls in the queue
Then HMI OP1 has in the active list a number of 0 calls
Then HMI OP1 has in the call queue a number of 3 calls
Then HMI OP1 has in the waiting list a number of 3 calls
Then HMI OP1 has in the collapsed area a number of 6 calls

Scenario: 4.25 Op1 answers one call
Then HMI OP1 answers item 1 from waiting call queue list

Scenario: 4.26 Op1 verifies the number of calls in the queue
Then HMI OP1 has in the active list a number of 1 calls
Then HMI OP1 has in the call queue a number of 4 calls
Then HMI OP1 has in the waiting list a number of 3 calls
Then HMI OP1 has in the collapsed area a number of 5 calls

Scenario: 4.27 Op1 terminates active call
Then HMI OP1 terminates item 1 from active call queue list

Scenario: 4.28 Op1 verifies the number of calls in the queue
Then HMI OP1 has in the active list a number of 0 calls
Then HMI OP1 has in the call queue a number of 3 calls
Then HMI OP1 has in the waiting list a number of 3 calls
Then HMI OP1 has in the collapsed area a number of 5 calls

Scenario: 4.29 Op1 answers one call
Then HMI OP1 answers item 1 from waiting call queue list

Scenario: 4.30 Op1 verifies the number of calls in the queue
Then HMI OP1 has in the active list a number of 1 calls
Then HMI OP1 has in the call queue a number of 4 calls
Then HMI OP1 has in the waiting list a number of 3 calls
Then HMI OP1 has in the collapsed area a number of 4 calls

Scenario: 4.31 Op1 terminates active call
Then HMI OP1 terminates item 1 from active call queue list

Scenario: 4.32 Op1 verifies the number of calls in the queue
Then HMI OP1 has in the active list a number of 0 calls
Then HMI OP1 has in the call queue a number of 3 calls
Then HMI OP1 has in the waiting list a number of 3 calls
Then HMI OP1 has in the collapsed area a number of 4 calls

Scenario: 4.33 Op1 answers one call
Then HMI OP1 answers item 1 from waiting call queue list

Scenario: 4.34 Op1 verifies the number of calls in the queue
Then HMI OP1 has in the active list a number of 1 calls
Then HMI OP1 has in the call queue a number of 4 calls
Then HMI OP1 has in the waiting list a number of 3 calls
Then HMI OP1 has in the collapsed area a number of 3 calls

Scenario: 4.35 Op1 terminates active call
Then HMI OP1 terminates item 1 from active call queue list

Scenario: 4.36 Op1 verifies the number of calls in the queue
Then HMI OP1 has in the active list a number of 0 calls
Then HMI OP1 has in the call queue a number of 3 calls
Then HMI OP1 has in the waiting list a number of 3 calls
Then HMI OP1 has in the collapsed area a number of 3 calls

Scenario: 4.37 Op1 answers one call
Then HMI OP1 answers item 1 from waiting call queue list

Scenario: 4.38 Op1 verifies the number of calls in the queue
Then HMI OP1 has in the active list a number of 1 calls
Then HMI OP1 has in the call queue a number of 4 calls
Then HMI OP1 has in the waiting list a number of 3 calls
Then HMI OP1 has in the collapsed area a number of 2 calls

Scenario: 4.39 Op1 terminates active call
Then HMI OP1 terminates item 1 from active call queue list

Scenario: 4.40 Op1 verifies the number of calls in the queue
Then HMI OP1 has in the active list a number of 0 calls
Then HMI OP1 has in the call queue a number of 3 calls
Then HMI OP1 has in the waiting list a number of 3 calls
Then HMI OP1 has in the collapsed area a number of 2 calls

Scenario: 5. Op1 answers one call
Meta:
@TEST_STEP_ACTION: Op1 answers one call
@TEST_STEP_REACTION: In the call queue there are: 1 active call, 3 calls are visible in the waiting list and collapsed area is not visible anymore
@TEST_STEP_REF: [CATS-REF: wXi5]
Then HMI OP1 answers item 1 from waiting call queue list

Scenario: 5.1 Op1 verifies the number of calls in the queue
Then HMI OP1 has in the active list a number of 1 calls
Then HMI OP1 has in the call queue a number of 5 calls
Then HMI OP1 has in the waiting list a number of 4 calls

Scenario: 6. Op1 terminates active call
Meta:
@TEST_STEP_ACTION: Op1 terminates active call 
@TEST_STEP_REACTION: In the call queue there are: 0 active call, 3 calls are visible in the waiting list and collapsed area is not visible anymore
@TEST_STEP_REF: [CATS-REF: lLjw]
Then HMI OP1 terminates item 1 from active call queue list

Scenario: 6.1 Op1 verifies the number of calls in the queue
Then HMI OP1 has in the active list a number of 0 calls
Then HMI OP1 has in the call queue a number of 4 calls
Then HMI OP1 has in the waiting list a number of 4 calls

Scenario: 7. Answering and terminate calls actions are repeated for the next 4 calls
Meta:
@TEST_STEP_ACTION: Answering and terminate calls actions are repeated for the next 4 calls
@TEST_STEP_REACTION: The call queue will be adapted accordingly: active call visible when answered, not visible when terminated, calls visible in the waiting call queue list will be decreasing by one with every answered call
@TEST_STEP_REF: [CATS-REF: TUWs]
Scenario: 7.1 Op1 answers one call
Then HMI OP1 answers item 1 from waiting call queue list

Scenario: 7.2 Op1 verifies the number of calls in the queue
Then HMI OP1 has in the active list a number of 1 calls
Then HMI OP1 has in the call queue a number of 4 calls
Then HMI OP1 has in the waiting list a number of 3 calls

Scenario: 7.3 Op1 terminates active call
Then HMI OP1 terminates item 1 from active call queue list

Scenario: 7.4 Op1 verifies the number of calls in the queue
Then HMI OP1 has in the active list a number of 0 calls
Then HMI OP1 has in the call queue a number of 3 calls
Then HMI OP1 has in the waiting list a number of 3 calls

Scenario: 7.5 Op1 answers one call
Then HMI OP1 answers item 1 from waiting call queue list

Scenario: 7.6 Op1 verifies the number of calls in the queue
Then HMI OP1 has in the active list a number of 1 calls
Then HMI OP1 has in the call queue a number of 3 calls
Then HMI OP1 has in the waiting list a number of 2 calls

Scenario: 7.7 Op1 terminates active call
Then HMI OP1 terminates item 1 from active call queue list

Scenario: 7.8 Op1 verifies the number of calls in the queue
Then HMI OP1 has in the active list a number of 0 calls
Then HMI OP1 has in the call queue a number of 2 calls
Then HMI OP1 has in the waiting list a number of 2 calls

Scenario: 7.9 Op1 answers one call
Then HMI OP1 answers item 1 from waiting call queue list

Scenario: 7.10 Op1 verifies the number of calls in the queue
Then HMI OP1 has in the active list a number of 1 calls
Then HMI OP1 has in the call queue a number of 2 calls
Then HMI OP1 has in the waiting list a number of 1 calls

Scenario: 7.11 Op1 terminates active call
Then HMI OP1 terminates item 1 from active call queue list

Scenario: 7.12 Op1 verifies the number of calls in the queue
Then HMI OP1 has in the active list a number of 0 calls
Then HMI OP1 has in the call queue a number of 1 calls
Then HMI OP1 has in the waiting list a number of 1 calls

Scenario: 7.13 Op1 answers one call
Then HMI OP1 answers item 1 from waiting call queue list

Scenario: 7.14 Op1 verifies the number of calls in the queue
Then HMI OP1 has in the active list a number of 1 calls
Then HMI OP1 has in the call queue a number of 1 calls
Then HMI OP1 has in the waiting list a number of 0 calls

Scenario: 7.15 Op1 terminates active call
Then HMI OP1 terminates item 1 from active call queue list

Scenario: 7.16 Op1 verifies the number of calls in the queue
Then HMI OP1 has in the active list a number of 0 calls
Then HMI OP1 has in the call queue a number of 0 calls
Then HMI OP1 has in the waiting list a number of 0 calls

Scenario: Remove phone
When SipContact is removed

Scenario: A scenario that is only executed in case of an execution failure
Meta: @RunOnFailure
GivenStories: voice_GG/ui/includes/@CleanupUICallQueue.story,
			  voice_GG/ui/includes/@CleanupUIMission.story,
			  voice_GG/ui/includes/@CleanupUIFunctionKeys.story,
			  voice_GG/ui/includes/@CleanupUIWindows.story
Then waiting for 1 millisecond



