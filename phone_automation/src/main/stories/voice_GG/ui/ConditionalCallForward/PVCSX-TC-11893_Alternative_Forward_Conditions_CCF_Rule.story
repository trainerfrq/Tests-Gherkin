Meta:
@TEST_CASE_VERSION: V8
@TEST_CASE_NAME: Alternative Forward Conditions CCF Rule
@TEST_CASE_DESCRIPTION: As an operator having a Conditional Call Forward Rule set with different destinations for each forward condition
I want to establish calls that activate the rule and fits each forward condition
So I can verify that the call will be forwarded with respect to matching condition
@TEST_CASE_PRECONDITION: Settings:
A Conditional Call Forward rule is set with:
- matching call destination: TWR, which is a role assigned only to one mission
- forward calls on:                           *out of service: OP1                           *reject: OP3                           *no reply: OP3, within 20 seconds
-number of rule iterations: 0
At the beginning, none of the operators will have TWR role assigned.
@TEST_CASE_PASS_FAIL_CRITERIA: The test is passed if each call is forwarded with the respect to its matching condition
@TEST_CASE_DEVICES_IN_USE: OP1, OP2, OP3
@TEST_CASE_ID: PVCSX-TC-11893
@TEST_CASE_GLOBAL_ID: GID-5154907
@TEST_CASE_API_ID: 17697697

Scenario: Booking profiles
Given booked profiles:
| profile | group          | host           | identifier |
| javafx  | hmi            | <<CLIENT1_IP>> | HMI OP1    |
| javafx  | hmi            | <<CLIENT2_IP>> | HMI OP2    |
| javafx  | hmi            | <<CLIENT3_IP>> | HMI OP3    |
| voip    | <<systemName>> | <<CO3_IP>>     | VOIP       |

Scenario: Define call queue items
Given the call queue items:
| key     | source                 | target                  | callType |
| TWR-OP2 | sip:507721@example.com |                         | DA/IDA   |
| GND-TWR | sip:507722@example.com | sip:507721@example.com  | DA/IDA   |

Scenario: Precondition - OP2 changes its mission to GND
When HMI OP2 with layout <<LAYOUT_MISSION2>> presses function key MISSIONS
Then HMI OP2 changes current mission to mission <<MISSION_GND_NAME>>
Then HMI OP2 activates mission
Then waiting for 5 seconds

Scenario: 1. OP2 establishes a call to TWR
Meta:
@TEST_STEP_ACTION: OP2 establishes a call to TWR
@TEST_STEP_REACTION: OP2 has a ringing call to TWR and OP1 has a call from OP2's master role in the waiting list
@TEST_STEP_REF: [CATS-REF: VfWp]
When HMI OP2 presses DA key TWR
Then HMI OP2 has the call queue item TWR-OP2 in state out_ringing

Scenario: 1.1 OP1 receives the call
Then HMI OP1 has the call queue item GND-TWR in state inc_initiated

Scenario: 1.2 Verifying call queue section
Then HMI OP2 has the call queue item TWR-OP2 in the active list with name label TWR
Then HMI OP1 has the call queue item GND-TWR in the waiting list with name label GND

Scenario: 2. OP2 terminates the call
Meta:
@TEST_STEP_ACTION: OP2 terminates the call
@TEST_STEP_REACTION: The call is terminated for both OP2 and OP1
@TEST_STEP_REF: [CATS-REF: EbaP]
When HMI OP2 presses DA key TWR
Then HMI OP2 has in the call queue a number of 0 calls
Then HMI OP1 has in the call queue a number of 0 calls

Scenario: 3. OP1 changes its mission to TWR
Meta:
@TEST_STEP_ACTION: OP1 changes its mission to TWR
@TEST_STEP_REACTION: OP1 has TWR mission assigned
@TEST_STEP_REF: [CATS-REF: pjg1]
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key MISSIONS
Then HMI OP1 changes current mission to mission <<MISSION_TWR_NAME>>
Then HMI OP1 activates mission
Then waiting for 5 seconds

Scenario: 3.1 Verify operator mission
Then HMI OP1 has in the DISPLAY STATUS section mission the assigned mission <<MISSION_TWR_NAME>>

Scenario: 4. OP2 establishes a call to TWR
Meta:
@TEST_STEP_ACTION: OP2 establishes a call to TWR
@TEST_STEP_REACTION: OP2 has a ringing call to TWR and OP1 has a call from OP2's master role in the waiting list
@TEST_STEP_REF: [CATS-REF: JdeW]
When HMI OP2 presses DA key TWR
Then HMI OP2 has the call queue item TWR-OP2 in state out_ringing

Scenario: 4.1 OP1 receives the call
Then HMI OP1 has the call queue item GND-TWR in state inc_initiated

Scenario: 4.2 Verifying call queue section
Then HMI OP2 has the call queue item TWR-OP2 in the active list with name label TWR
Then HMI OP1 has the call queue item GND-TWR in the waiting list with name label GND

Scenario: 5. OP1 rejects the call
Meta:
@TEST_STEP_ACTION: OP1 rejects the call
@TEST_STEP_REACTION: OP2 has a ringing call to TWR and OP3 has a call from OP2's master role in the waiting list
@TEST_STEP_REF: [CATS-REF: 9JlZ]
Then HMI OP1 rejects the waiting call queue item from waiting list
Then HMI OP1 has in the call queue a number of 0 calls

Scenario: 5.1 OP2 still has a ringing call
Then HMI OP2 has the call queue item TWR-OP2 in state out_ringing

Scenario: 5.2 OP3 receives the call
Then HMI OP3 has the call queue item GND-TWR in state inc_initiated
Then HMI OP3 has the call queue item GND-TWR in the waiting list with name label GND

Scenario: 6. OP2 terminates the call
Meta:
@TEST_STEP_ACTION: OP2 terminates the call
@TEST_STEP_REACTION: The call is terminated for both OP2 and OP3
@TEST_STEP_REF: [CATS-REF: FTSA]
When HMI OP2 presses DA key TWR
Then HMI OP2 has in the call queue a number of 0 calls
Then HMI OP3 has in the call queue a number of 0 calls

Scenario: 7. OP2 establishes a call to TWR
Meta:
@TEST_STEP_ACTION: OP2 establishes a call to TWR
@TEST_STEP_REACTION: OP2 has a ringing call to TWR and OP1 has a call from OP2's master role in the waiting list
@TEST_STEP_REF: [CATS-REF: Vkv5]
When HMI OP2 presses DA key TWR
Then HMI OP2 has the call queue item TWR-OP2 in state out_ringing

Scenario: 7.1 OP1 receives the call
Then HMI OP1 has the call queue item GND-TWR in state inc_initiated

Scenario: 7.2 Verifying call queue section
Then HMI OP2 has the call queue item TWR-OP2 in the active list with name label TWR
Then HMI OP1 has the call queue item GND-TWR in the waiting list with name label GND

Scenario: 8. OP2 is waiting for 20 seconds
Meta:
@TEST_STEP_ACTION: OP2 is waiting for 20 seconds
@TEST_STEP_REACTION: OP2 has a ringing call to TWR, the call is terminated for OP1 and OP3 has a call from OP2's master role in the waiting list
@TEST_STEP_REF: [CATS-REF: V]
When waiting for 20 seconds
Then HMI OP2 has the call queue item TWR-OP2 in state out_ringing

Scenario: 8.1 OP1 has no calls
Then HMI OP1 has in the call queue a number of 0 calls

Scenario: 8.2 Verifying calls queue section
Then HMI OP2 has the call queue item TWR-OP2 in the active list with name label TWR
Then HMI OP3 has the call queue item GND-TWR in the waiting list with name label GND

Scenario: 9. OP2 terminates the call
Meta:
@TEST_STEP_ACTION: OP2 terminates the call
@TEST_STEP_REACTION: The call is terminated for both OP2 and OP3
@TEST_STEP_REF: [CATS-REF: FTSA]
When HMI OP2 presses DA key TWR
Then HMI OP2 has in the call queue a number of 0 calls
Then HMI OP3 has in the call queue a number of 0 calls

Scenario: Cleanup - OP1 changes its mission back
When HMI OP1 with layout <<COMMON_LAYOUT>> presses function key MISSIONS
Then HMI OP1 changes current mission to mission <<MISSION_1_NAME>>
Then HMI OP1 activates mission
Then waiting for 5 seconds

Scenario: Cleanup - OP2 changes its mission back
When HMI OP2 with layout <<COMMON_LAYOUT>> presses function key MISSIONS
Then HMI OP2 changes current mission to mission <<MISSION_2_NAME>>
Then HMI OP2 activates mission
Then waiting for 5 seconds

Scenario: A scenario that is only executed in case of an execution failure
Meta: @RunOnFailure
GivenStories: voice_GG/ui/includes/@CleanupStory.story
Then waiting until the cleanup is done
