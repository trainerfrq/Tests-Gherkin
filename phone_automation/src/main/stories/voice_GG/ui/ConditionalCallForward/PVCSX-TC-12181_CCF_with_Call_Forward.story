Meta:
@TEST_CASE_VERSION: V2
@TEST_CASE_NAME: CCF with Call Forward
@TEST_CASE_DESCRIPTION: As an operator having Call Forward set to a target which is also a matching destination of a Conditional Call Forward rule
I want to establish a call to this operator
So I can verify that the call is forwarded according to the Conditional Call Forward rule
@TEST_CASE_PRECONDITION: Settings:
- Mission TWR has only Role TWR assigned
A Conditional Call Forward rule is set with:
- matching call destination: TWR
- forward calls on:                           *out of service: OP1                           *reject: no forwarding                           *no reply: no forwarding
-number of rule iterations: 0
None of the operators have TWR role assigned.
@TEST_CASE_PASS_FAIL_CRITERIA: The test is passed if OP1 has a ringing call
@TEST_CASE_DEVICES_IN_USE: OP1, OP2, OP3
@TEST_CASE_ID: PVCSX-TC-12181
@TEST_CASE_GLOBAL_ID: GID-5184180
@TEST_CASE_API_ID: 17949547

Scenario: Booking profiles
Given booked profiles:
| profile | group          | host           | identifier |
| javafx  | hmi            | <<CLIENT1_IP>> | HMI OP1    |
| javafx  | hmi            | <<CLIENT2_IP>> | HMI OP2    |
| javafx  | hmi            | <<CLIENT3_IP>> | HMI OP3    |

Scenario: Define call queue items
Given the call queue items:
| key             | source                  | target                 | callType   |
| OP3-OP2         | <<OP3_URI>>             | <<OP2_URI>>            | DA/IDA     |
| OP2-TWR         | <<OP2_URI>>             | sip:507721@example.com | DA/IDA     |

Scenario: 1. OP3 activates Call Forward
Meta:
@TEST_STEP_ACTION: OP3 activates Call Forward
@TEST_STEP_REACTION: OP3 has Call Forward function key in Forward On Going state
@TEST_STEP_REF: [CATS-REF: A5Qg]
When HMI OP3 with layout <<LAYOUT_MISSION3>> presses function key CALLFORWARD
Then HMI OP3 with layout <<LAYOUT_MISSION3>> has the function key CALLFORWARD in forwardOngoing state
Then HMI OP3 verifies that call queue info container is not visible

Scenario: 2. OP3 chooses TWR as Call Forward target
Meta:
@TEST_STEP_ACTION: OP3 chosses TWR as Call Forward target
@TEST_STEP_REACTION: OP3 has Call Forward mode active with target: TWR
@TEST_STEP_REF: [CATS-REF: c17h]
When HMI OP3 with layout <<LAYOUT_MISSION3>> selects grid tab 3
When HMI OP3 presses DA key TWR
Then HMI OP3 with layout <<LAYOUT_MISSION3>> has the function key CALLFORWARD in active state
Then HMI OP3 verifies that call queue info container is visible
Then HMI OP3 verifies that call queue info container contains Target: TWR
Then HMI OP3 has in the call queue a number of 0 calls

Scenario: 3. OP2 establishes a call to OP3
Meta:
@TEST_STEP_ACTION: OP2 establishes a call to OP3
@TEST_STEP_REACTION: OP2 has a ringing call to TWR and OP1 has a call from OP2
@TEST_STEP_REF: [CATS-REF: 3WgG]
When HMI OP2 presses DA key OP3
Then HMI OP2 has the DA key OP3 in state out_ringing
Then HMI OP2 has the call queue item OP3-OP2 in the active list with name label <<MISSION_TWR_NAME>>

Scenario: 3.1 OP1 verifies its call queue
Then HMI OP1 has the call queue item OP2-TWR in state inc_initiated
Then HMI OP1 has the call queue item OP2-TWR in the waiting list with name label <<OP2_NAME>>

Scenario: 4. OP2 terminates the call
Meta:
@TEST_STEP_ACTION: OP2 terminates the call
@TEST_STEP_REACTION: The call is terminated for both OP2 and OP1
@TEST_STEP_REF: [CATS-REF: a8Tt]
When HMI OP2 presses DA key OP3
Then HMI OP2 has in the call queue a number of 0 calls
Then HMI OP2 has in the call queue a number of 0 calls

Scenario: 5. OP3 deactivates Call Forward
Meta:
@TEST_STEP_ACTION: OP3 deactivates Call Forward
@TEST_STEP_REACTION: Call Forward mode is not active anymore
@TEST_STEP_REF: [CATS-REF: 67UT]
When HMI OP3 with layout <<LAYOUT_MISSION3>> presses function key CALLFORWARD
Then HMI OP3 verifies that call queue info container is not visible

Scenario: Cleanup - OP3 changes its layout grid tab back
When HMI OP3 with layout <<LAYOUT_MISSION3>> selects grid tab 1

Scenario: A scenario that is only executed in case of an execution failure
Meta: @RunOnFailure
GivenStories: voice_GG/ui/includes/@CleanupStory.story
Then waiting until the cleanup is done
