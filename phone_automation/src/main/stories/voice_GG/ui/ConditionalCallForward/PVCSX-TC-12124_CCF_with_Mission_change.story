Meta:
@TEST_CASE_VERSION: V2
@TEST_CASE_NAME: CCF with Mission change
@TEST_CASE_DESCRIPTION: As an operator having an active role that fits the matching destination of a Conditional Call Forward rule
I want to receive a call and then to change the mission
So I can verify that the call is forwarded according to the rule even if the mission was changed
@TEST_CASE_PRECONDITION: Settings:
Mission TWR has a single role assigned called TWR
Mission WEST-EXEC
A Conditional Call Forward rule is set with:
- matching call destination: TWR
- forward calls on:                           *out of service: no forwarding                           *reject: OP3                           *no reply: no forwarding
-number of rule iterations: 0
At the beginning, OP1 will have TWR role assigned.
@TEST_CASE_PASS_FAIL_CRITERIA: The test is passed if OP3 receives a call after OP1 (after a mission change) reject its incoming call 
@TEST_CASE_DEVICES_IN_USE: OP1, OP2, OP3
@TEST_CASE_ID: PVCSX-TC-12124
@TEST_CASE_GLOBAL_ID: GID-5181351
@TEST_CASE_API_ID: 17908221

Scenario: Booking profiles
Given booked profiles:
| profile | group          | host           | identifier |
| javafx  | hmi            | <<CLIENT1_IP>> | HMI OP1    |
| javafx  | hmi            | <<CLIENT2_IP>> | HMI OP2    |
| javafx  | hmi            | <<CLIENT3_IP>> | HMI OP3    |

Scenario: Define call queue items
Given the call queue items:
| key             | source                  | target                 | callType   |
| ROLE2-TWR       | <<ROLE2_URI>>           | sip:507721@example.com | DA/IDA     |
| TWR-ROLE2       | sip:507721@example.com  |                        | DA/IDA     |
| OP1-OP2         | <<OP1_URI>>             | <<OP2_URI>>            | DA/IDA     |
| OP2-OP1         | <<OP2_URI>>             | <<OP1_URI>>            | DA/IDA     |

Scenario: OP1 changes its mission to TWR
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key MISSIONS
Then HMI OP1 changes current mission to mission <<MISSION_TWR_NAME>>
Then HMI OP1 activates mission
Then waiting for 5 seconds

Scenario: 1. OP2 establishes a call to TWR
Meta:
@TEST_STEP_ACTION: OP2 establishes a call to TWR
@TEST_STEP_REACTION: OP2 has a ringing call to TWR and OP1 has a call from OP2's master role in the waiting list
@TEST_STEP_REF: [CATS-REF: J0a1]
When HMI OP2 with layout <<LAYOUT_MISSION2>> selects grid tab 3
When HMI OP2 presses DA key TWR
Then HMI OP2 has the call queue item TWR-ROLE2 in state out_ringing

Scenario: 1.1 OP1 receives the call
Then HMI OP1 has the call queue item ROLE2-TWR in state inc_initiated

Scenario: 1.2 Verifying call queue section
Then HMI OP2 has the call queue item TWR-ROLE2 in the active list with name label <<MISSION_TWR_NAME>>
Then HMI OP1 has the call queue item ROLE2-TWR in the waiting list with name label <<ROLE_2_NAME>>

Scenario: 2. OP1 changes its mission to WEST-EXEC
Meta:
@TEST_STEP_ACTION: OP1 changes its mission to WEST-EXEC
@TEST_STEP_REACTION: OP1 has WEST-EXEC mission assigned
@TEST_STEP_REF: [CATS-REF: 10Xr]
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key MISSIONS
Then HMI OP1 changes current mission to mission <<MISSION_2_NAME>>
Then HMI OP1 activates mission
Then waiting for 5 seconds

Scenario: 2.1 Verify operator mission
Then HMI OP1 has in the DISPLAY STATUS section mission the assigned mission <<MISSION_2_NAME>>

Scenario: 3. OP1 rejects the call
Meta:
@TEST_STEP_ACTION: OP1 rejects the call
@TEST_STEP_REACTION: OP1 has no calls in queue, OP2 has a ringing call to TWR and the call is forwarded to OP3 which has a call from OP2's master role in the waiting list
@TEST_STEP_REF: [CATS-REF: fuSx]
Then HMI OP1 rejects the waiting call queue item from waiting list
Then HMI OP1 has in the call queue a number of 0 calls

Scenario: 3.1 OP2 still has a ringing call
Then HMI OP2 has the call queue item TWR-ROLE2 in state out_ringing
Then HMI OP2 has the call queue item TWR-ROLE2 in the active list with name label <<MISSION_TWR_NAME>>

Scenario: 3.2 OP3 receives the call
Then HMI OP3 has in the call queue a number of 1 calls
Then HMI OP3 has the call queue item ROLE2-TWR in state inc_initiated
Then HMI OP3 has the call queue item ROLE2-TWR in the waiting list with name label <<ROLE_2_NAME>>

Scenario: 4. OP2 terminates the call
Meta:
@TEST_STEP_ACTION: OP2 terminates the call
@TEST_STEP_REACTION: The call is terminate for both OP2 and OP3
@TEST_STEP_REF: [CATS-REF: bFw5]
When HMI OP2 presses DA key TWR
Then HMI OP2 has in the call queue a number of 0 calls
Then HMI OP3 has in the call queue a number of 0 calls

Scenario: 5. OP2 establishes a call to OP1
Meta:
@TEST_STEP_ACTION: OP2 establishes a call to OP1
@TEST_STEP_REACTION:  OP2 has a ringing call to OP1 and OP1 has a call from OP2 in the waiting list
@TEST_STEP_REF: [CATS-REF: Rluo]
When HMI OP2 with layout <<LAYOUT_MISSION2>> selects grid tab 1
When HMI OP2 presses DA key OP1
Then HMI OP2 has the call queue item OP1-OP2 in state out_ringing

Scenario: 5.1 OP1 receives the call
Then HMI OP1 has the call queue item OP2-OP1 in state inc_initiated

Scenario: 5.2 Verifying call queue section
Then HMI OP2 has the call queue item OP1-OP2 in the active list with name label <<OP1_NAME>>
Then HMI OP1 has the call queue item OP2-OP1 in the waiting list with name label <<OP2_NAME>>

Scenario: 6. OP1 changes its mission to TWR
Meta:
@TEST_STEP_ACTION: OP1 changes its mission to TWR
@TEST_STEP_REACTION: OP1 has TWR mission assigned
@TEST_STEP_REF: [CATS-REF: vStR]
When HMI OP1 with layout <<LAYOUT_MISSION2>> presses function key MISSIONS
Then HMI OP1 changes current mission to mission <<MISSION_TWR_NAME>>
Then HMI OP1 activates mission
Then waiting for 5 seconds

Scenario: 6.1 Verify operator mission
Then HMI OP1 has in the DISPLAY STATUS section mission the assigned mission <<MISSION_TWR_NAME>>

Scenario: 7. OP1 rejects the call
Meta:
@TEST_STEP_ACTION: OP1 rejects the call
@TEST_STEP_REACTION: Because OP1 had mission WEST-EXEC assigned, the rule was not activated when the call was established. The call is terminated for both OP2 and OP1
@TEST_STEP_REF: [CATS-REF: cI80]
Then HMI OP1 rejects the waiting call queue item from waiting list
Then HMI OP1 has in the call queue a number of 0 calls
Then HMI OP2 verifies that the DA key OP1 has the info label busy

Scenario: Cleanup - OP2 cleans the calls queue
Then HMI OP2 presses item 1 from active call queue list

Scenario: Cleanup - OP1 changes its mission back
When HMI OP1 with layout <<COMMON_LAYOUT>> presses function key MISSIONS
Then HMI OP1 changes current mission to mission <<MISSION_1_NAME>>
Then HMI OP1 activates mission
Then waiting for 5 seconds

Scenario: A scenario that is only executed in case of an execution failure
Meta: @RunOnFailure
GivenStories: voice_GG/ui/includes/@CleanupStory.story
Then waiting until the cleanup is done
