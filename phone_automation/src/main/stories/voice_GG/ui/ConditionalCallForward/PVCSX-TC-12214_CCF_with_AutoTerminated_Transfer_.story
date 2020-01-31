Meta:
@TEST_CASE_VERSION: V7
@TEST_CASE_NAME: CCF with AutoTerminated Transfer 
@TEST_CASE_DESCRIPTION: As an operator having an active call and a Conditional Call Forward rule set
I want to transfer the call to the rule matching destination 
So I can verify that the call is transferred according to the rule and the initial call is terminated
@TEST_CASE_PRECONDITION: Mission TWR has a single role assigned called TWR
Settings:
A Conditional Call Forward with:
- matching call destinations: TWR
- forward calls on:                           *out of service: OP1                           *reject: no call forwarding                           *no reply: no call forwarding
- number of rule iterations: 0
None of the Operators will have TWR role assigned
@TEST_CASE_PASS_FAIL_CRITERIA: The test is passed if initial call is terminated
@TEST_CASE_DEVICES_IN_USE: OP1, OP2 
@TEST_CASE_ID: PVCSX-TC-12214
@TEST_CASE_GLOBAL_ID: GID-5188685
@TEST_CASE_API_ID: 17982980

Scenario: Booking profiles
Given booked profiles:
| profile | group          | host           | identifier |
| javafx  | hmi            | <<CLIENT1_IP>> | HMI OP1    |
| javafx  | hmi            | <<CLIENT2_IP>> | HMI OP2    |
| javafx  | hmi            | <<CLIENT3_IP>> | HMI OP3    |
| voip    | <<systemName>> | <<CO3_IP>>     | VOIP       |

Scenario: Define call queue items
Given the call queue items:
| key             | source                  | target                 | callType   |
| OP1-OP2         | <<OP1_URI>>             | <<OP2_URI>>            | DA/IDA     |
| OP2-OP1         | <<OP2_URI>>             | <<OP1_URI>>            | DA/IDA     |
| ROLE2-TWR       | <<ROLE2_URI>>           | sip:507721@example.com | DA/IDA     |

Scenario: 1. OP2 establishes a call to OP1
Meta:
@TEST_STEP_ACTION: OP2 establishes a call to OP1
@TEST_STEP_REACTION: OP2 has a ringing call to OP1 and OP1 has a call from OP2 in the waiting list
@TEST_STEP_REF: [CATS-REF: MOQr]
When HMI OP2 presses DA key OP1
Then HMI OP2 has the DA key OP1 in state out_ringing
Then HMI OP2 has the call queue item OP1-OP2 in the active list with name label <<OP1_NAME>>

Scenario: 1.1 OP1 receives the incoming call
Then HMI OP1 has the DA key OP2 in state inc_initiated
Then HMI OP1 has the call queue item OP2-OP1 in the waiting list with name label <<OP2_NAME>>

Scenario: 2. OP1 answers the call
Meta:
@TEST_STEP_ACTION: OP1 answers the call
@TEST_STEP_REACTION: The call is connected for both OP1 and OP2
@TEST_STEP_REF: [CATS-REF: 8bhI]
When HMI OP1 presses DA key OP2

Scenario: 2.1 Verify call is connected for both operators
Then HMI OP1 has the call queue item OP2-OP1 in state connected
Then HMI OP2 has the call queue item OP1-OP2 in state connected

Scenario: 3. OP2 initiates the transfer
Meta:
@TEST_STEP_ACTION: OP2 initiates the transfer
@TEST_STEP_REACTION: OP2 has a call on hold and OP1 has a call on held
@TEST_STEP_REF: [CATS-REF: 7ZzG]
When HMI OP2 initiates a transfer on the active call

Scenario: 3.1 Verify call is put on hold respectively held
Then HMI OP2 has the call queue item OP1-OP2 in state hold
Then HMI OP1 has the call queue item OP2-OP1 in state held

Scenario: 3.2 Verify call transfer is initiated
Then HMI OP2 has the call conditional flag set for call queue item OP1-OP2
Then HMI OP2 has the call queue item OP1-OP2 in the hold list with info label XFR Hold

Scenario: 4. OP2 chooses TWR as transfer target
Meta:
@TEST_STEP_ACTION: OP2 chooses TWR as transfer target
@TEST_STEP_REACTION: OP1 has a call on held and a ringing call from OP2's master role. OP2 has a call on hold and a ringing call to TWR
@TEST_STEP_REF: [CATS-REF: Rqmb]
When HMI OP2 with layout <<LAYOUT_MISSION2>> selects grid tab 3
When HMI OP2 presses DA key TWR
Then HMI OP2 has in the call queue a number of 2 calls
Then HMI OP2 has the DA key TWR in state out_ringing

Scenario: 4.1 OP2 has also a call on hold
Then HMI OP2 has the call queue item OP1-OP2 in state hold
Then HMI OP2 has the call conditional flag set for call queue item OP1-OP2
Then HMI OP2 has the call queue item OP1-OP2 in the hold list with info label XFR Hold

Scenario: 4.2 OP1 receives the incoming call
Then HMI OP1 has in the call queue a number of 2 calls
Then HMI OP1 has the DA key <<ROLE_2_NAME>> in state inc_initiated
Then HMI OP1 has the call queue item ROLE2-TWR in state inc_initiated
Then HMI OP1 has the call queue item ROLE2-TWR in the waiting list with name label <<ROLE_2_NAME>>

Scenario: 4.3 OP1 still has a call on held
Then HMI OP1 has the call queue item OP2-OP1 in state held

Scenario: 5. OP2 transfers the call to TWR
Meta:
@TEST_STEP_ACTION: OP2 transfers the call to TWR
@TEST_STEP_REACTION: OP1 has a ringing call from OP2's master role, the call in held being terminated. OP2 has an active call to TWR, the call on hold being terminated
@TEST_STEP_REF: [CATS-REF: CLAA]
When HMI OP2 presses DA key TWR
Then HMI OP2 has in the call queue a number of 1 calls
Then HMI OP2 has the DA key TWR in state out_ringing

Scenario: Veryfing OP1 call queue section
Then HMI OP1 has the DA key OP2 in state terminated
Then HMI OP1 has the call queue item ROLE2-TWR in state inc_initiated
Then HMI OP1 has the DA key <<ROLE_2_NAME>> in state inc_initiated

Scenario: 6. OP2 terminates the call
Meta:
@TEST_STEP_ACTION: OP2 terminates the call
@TEST_STEP_REACTION: The call is terminated for both OP1 and OP2
@TEST_STEP_REF: [CATS-REF: sXkw]
When HMI OP2 presses DA key TWR
Then HMI OP2 has in the call queue a number of 0 calls
Then HMI OP2 has the DA key TWR in state terminated

Scenario: 6.1 The call is terminated also for OP1
Then HMI OP1 has the DA key <<ROLE_2_NAME>> in state terminated

Scenario: Cleanup - OP1 cleans the calls queue
Then HMI OP1 presses item 1 from active call queue list

Scenario: Cleanup - OP2 changes its layout grid tab back
When HMI OP2 with layout <<LAYOUT_MISSION2>> selects grid tab 1

Scenario: A scenario that is only executed in case of an execution failure
Meta: @RunOnFailure
GivenStories: voice_GG/ui/includes/@CleanupStory.story
Then waiting until the cleanup is done
