Meta: @TEST_CASE_VERSION: V8
@TEST_CASE_NAME: MaximumIncomingCallsAndCallForward
@TEST_CASE_DESCRIPTION: As an operator having 16 incoming external calls I want to activate call forward So I can verify that all other calls made towards my position will be forward to another operator position
@TEST_CASE_PRECONDITION:
@TEST_CASE_PASS_FAIL_CRITERIA: The test is passed when calls are forwarded automatically to the selected target and operator can answers the 16 incoming calls
@TEST_CASE_DEVICES_IN_USE: CATS tool is used to simulate 16 external DA calls
@TEST_CASE_ID: PVCSX-TC-11647
@TEST_CASE_GLOBAL_ID: GID-5112013
@TEST_CASE_API_ID: 17055583

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

Scenario: 1. Have 16 external DA calls that call Op1
Meta: @TEST_STEP_ACTION: Have 16 external DA calls that call Op1
@TEST_STEP_REACTION: Op1 has 16 incoming calls
@TEST_STEP_REF: [CATS-REF: 6GOg]
When SipContact calls SIP URI <<OPVOICE1_PHONE_URI>>
Then waiting for 2 seconds

Scenario: 1.1 Op1 verifies the number of incoming calls in the queue
Then HMI OP1 has in the call queue a number of 3 calls
Then HMI OP1 has in the waiting list a number of 3 calls
Then HMI OP1 has in the collapsed area a number of 13 calls

Scenario: 2. Op1 activates Call Forward and chooses Op2 as call forward target
Meta: @TEST_STEP_ACTION: Op1 activates Call Forward and chooses Op2 as call forward target
@TEST_STEP_REACTION: Op1 has Call Forward activated with target Op2. Op1 has 16 incoming calls
@TEST_STEP_REF: [CATS-REF: kJNr]
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key CALLFORWARD

Scenario: 2.1 Op1 chooses Op2 as call forward target
When HMI OP1 presses DA key OP2
Then HMI OP1 verifies that call queue info container contains Target: <<OP2_NAME>>

Scenario: 2.2 Op1 verifies the number of incoming calls in the queue
Then HMI OP1 has in the call queue a number of 2 calls
Then HMI OP1 has in the waiting list a number of 2 calls
Then HMI OP1 has in the collapsed area a number of 14 calls

Scenario: 3. Op3 calls Op1
Meta: @TEST_STEP_ACTION: Op3 calls Op1
@TEST_STEP_REACTION: Call is forwarded automatically to Op2. Op1 has 16 incoming calls
@TEST_STEP_REF: [CATS-REF: vA2n]
When HMI OP3 presses DA key OP1
Then HMI OP3 has the DA key OP1 in state out_ringing

Scenario: 3.1 Call is automatically forwarded to Op2
Then HMI OP2 has the DA key OP3 in state inc_initiated

Scenario: 3.2 Op1 verifies the number of incoming calls in the queue
Then HMI OP1 has in the call queue a number of 2 calls
Then HMI OP1 has in the waiting list a number of 2 calls
Then HMI OP1 has in the collapsed area a number of 14 calls

Scenario: 4. Op3 ends call
Meta: @TEST_STEP_ACTION: Op3 ends call
@TEST_STEP_REACTION: Op3 and Op2 have no calls in the call queue. Op1 has 16 incoming calls
@TEST_STEP_REF: [CATS-REF: 0KGZ]
When HMI OP3 presses DA key OP1
Then HMI OP3 has in the call queue a number of 0 calls

Scenario: 4.1 Call is terminated also for Op2
Then HMI OP2 has in the call queue a number of 0 calls

Scenario: 4.2 Op1 verifies the number of incoming calls in the queue
Then HMI OP1 has in the call queue a number of 2 calls
Then HMI OP1 has in the waiting list a number of 2 calls
Then HMI OP1 has in the collapsed area a number of 14 calls

Scenario: 5. Op1 answers and terminates the 16 incoming calls
Meta: @TEST_STEP_ACTION: Op1 answers and terminates the 16 incoming calls
@TEST_STEP_REACTION: Op1 has no calls in the call queue
@TEST_STEP_REF: [CATS-REF: pwi7]
Then HMI OP1 answers and terminates a number of 16 calls

Scenario: 5.1 Op1 verifies the number of calls in the queue
Then HMI OP1 has in the call queue a number of 0 calls

Scenario: 6. Op1 deactivates Call Forward
Meta: @TEST_STEP_ACTION: Op1 deactivates Call Forward
@TEST_STEP_REACTION: Op1 has Call Forward deactivated
@TEST_STEP_REF: [CATS-REF: tEu4]
Then HMI OP1 with layout <<LAYOUT_MISSION1>> has the function key CALLFORWARD in active state
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key CALLFORWARD
Then HMI OP1 verifies that call queue info container is not visible

Scenario: Remove phone
When SipContact is removed

Scenario: A scenario that is only executed in case of an execution failure
Meta: @RunOnFailure
GivenStories: voice_GG/ui/includes/@CleanupStory.story
Then waiting until the cleanup is done
