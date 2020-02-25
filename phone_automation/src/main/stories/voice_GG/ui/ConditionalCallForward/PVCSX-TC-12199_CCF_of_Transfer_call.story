Meta:
@TEST_CASE_VERSION: V6
@TEST_CASE_NAME: CCF of Transfer call
@TEST_CASE_DESCRIPTION: As an operator having an active call and a Conditional Call Forward rule set
I want to transfer the call to the rule matching destination
So I can verify that the call is transferred according to the rule
@TEST_CASE_PRECONDITION: Settings:
- Mission TWR has only Role TWR assigned
A Conditional Call Forward rule is set with:
- matching call destination: TWR
- forward calls on:                           *out of service: OP1                           *reject: no forwarding                           *no reply: no forwarding
-number of rule iterations: 0
None of the Operators have TWR role assigned.
@TEST_CASE_PASS_FAIL_CRITERIA: This test is passed if the transferred call to matching call destination of the configured rule is forwarded as configured
@TEST_CASE_DEVICES_IN_USE: OP1, OP2, OP3
@TEST_CASE_ID: PVCSX-TC-12199
@TEST_CASE_GLOBAL_ID: GID-5187669
@TEST_CASE_API_ID: 17969316

Scenario: Booking profiles
Given booked profiles:
| profile | group          | host           | identifier |
| javafx  | hmi            | <<CLIENT1_IP>> | HMI OP1    |
| javafx  | hmi            | <<CLIENT2_IP>> | HMI OP2    |
| javafx  | hmi            | <<CLIENT3_IP>> | HMI OP3    |

Scenario: Define call queue items
Given the call queue items:
| key             | source                  | target                 | callType   |
| OP2-OP3         | <<OP2_URI>>             | <<OP3_URI>>            | DA/IDA     |
| OP3-OP2         | <<OP3_URI>>             | <<OP2_URI>>            | DA/IDA     |
| ROLE2-TWR       | <<ROLE2_URI>>           | sip:507721@example.com | DA/IDA     |
| TWR-OP3         | sip:507721@example.com  | <<OP3_URI>>            | DA/IDA     |
| OP3-TWR         | <<OP3_URI>>             | sip:507721@example.com | DA/IDA     |

Scenario: 1. OP2 establishes a call to OP3
Meta:
@TEST_STEP_ACTION: OP2 establishes a call to OP3
@TEST_STEP_REACTION: OP2 has a ringing call to OP3 and OP3 has a call from OP2 in the waiting list
@TEST_STEP_REF: [CATS-REF: HRzB]
When HMI OP2 presses DA key OP3
Then HMI OP2 has the DA key OP3 in state out_ringing
Then HMI OP2 has the call queue item OP3-OP2 in the active list with name label <<OP3_NAME>>

Scenario: 1.1 OP3 receives the incoming call
Then HMI OP3 has the DA key OP2 in state inc_initiated
Then HMI OP3 has the call queue item OP2-OP3 in the waiting list with name label <<OP2_NAME>>

Scenario: 2. OP3 answers the call
Meta:
@TEST_STEP_ACTION: OP3 answers the call
@TEST_STEP_REACTION: The call is connected for both OP2 and OP3
@TEST_STEP_REF: [CATS-REF: U1Ol]
When HMI OP3 presses DA key OP2

Scenario: 2.1 Verify call is connected for both operators
Then HMI OP3 has the call queue item OP2-OP3 in state connected
Then HMI OP2 has the call queue item OP3-OP2 in state connected

Scenario: 3. OP2 initiates the transfer
Meta:
@TEST_STEP_ACTION: OP2 initiates the transfer
@TEST_STEP_REACTION: OP2 has a call on hold and OP3 has a call on held
@TEST_STEP_REF: [CATS-REF: G0Ds]
When HMI OP2 initiates a transfer on the active call

Scenario: 3.1 Verify call is put on hold respectively held
Then HMI OP2 has the call queue item OP3-OP2 in state hold
Then HMI OP3 has the call queue item OP2-OP3 in state held

Scenario: 3.2 Verify call transfer is initiated
Then HMI OP2 has the call conditional flag set for call queue item OP3-OP2
Then HMI OP2 has the call queue item OP3-OP2 in the hold list with info label XFR Hold

Scenario: 4. OP2 chooses TWR as transfer target
Meta:
@TEST_STEP_ACTION: OP2 chooses TWR as transfer target
@TEST_STEP_REACTION: OP3 has a call on held from OP2, OP2 has a call on hold to OP3 and a ringing call to TWR and OP1 has a ringing call from OP2's master role
@TEST_STEP_REF: [CATS-REF: 3aY6]
When HMI OP2 with layout <<LAYOUT_MISSION2>> selects grid tab 3
When HMI OP2 presses DA key TWR
Then HMI OP2 has in the call queue a number of 2 calls
Then HMI OP2 has the DA key TWR in state out_ringing

Scenario: 4.1 OP2 has also a call on hold
Then HMI OP2 has the call queue item OP3-OP2 in state hold
Then HMI OP2 has the call conditional flag set for call queue item OP3-OP2
Then HMI OP2 has the call queue item OP3-OP2 in the hold list with info label XFR Hold

Scenario: 4.2 OP1 receives the incoming call
Then HMI OP1 has the call queue item ROLE2-TWR in state inc_initiated
Then HMI OP1 has the call queue item ROLE2-TWR in the waiting list with name label <<ROLE_2_NAME>>

Scenario: 4.3 OP3 still has a call on held
Then HMI OP3 has the call queue item OP2-OP3 in state held

Scenario: 5. OP2 transfers the call to TWR
Meta:
@TEST_STEP_ACTION: OP2 transfers the call to TWR
@TEST_STEP_REACTION: OP2 has no calls in queue, OP3 has an active call to TWR and OP1 has a ringing call from OP3
@TEST_STEP_REF: [CATS-REF: 7NrA]
When HMI OP2 presses DA key TWR
Then HMI OP2 has in the call queue a number of 0 calls

Scenario: 5.1 OP3 verifies its call queue section
Then HMI OP3 has in the call queue a number of 1 calls
Then HMI OP3 has the call queue item TWR-OP3 in state out_ringing
Then HMI OP3 has the call queue item TWR-OP3 in the active list with name label <<MISSION_TWR_NAME>>

Scenario: 5.2 OP1 verifies its call queue section
Then HMI OP1 has in the call queue a number of 1 calls
Then HMI OP1 has the call queue item OP3-TWR in state inc_initiated
Then HMI OP1 has the call queue item OP3-TWR in the waiting list with name label <<OP3_NAME>>

Scenario: 6. OP1 accepts the call
Meta:
@TEST_STEP_ACTION: OP1 accepts the call
@TEST_STEP_REACTION: The call is connected for both OP1 and OP3
@TEST_STEP_REF: [CATS-REF: W8mF]
Then HMI OP1 accepts the call queue item OP3-TWR
Then HMI OP1 has in the call queue a number of 1 calls
Then HMI OP3 has in the call queue a number of 1 calls

Scenario: 6.1 Verifying call queue section
Then HMI OP3 has the call queue item TWR-OP3 in state connected
Then HMI OP3 has the call queue item TWR-OP3 in the active list with name label <<MISSION_TWR_NAME>>
Then HMI OP1 has the call queue item OP3-TWR in state connected
Then HMI OP1 has the call queue item OP3-TWR in the active list with name label <<OP3_NAME>>

Scenario: 7. OP3 terminates the call
Meta:
@TEST_STEP_ACTION: OP3 terminates the call
@TEST_STEP_REACTION: The call is terminated for both OP1 and OP3
@TEST_STEP_REF: [CATS-REF: cTFi]
Then HMI OP3 terminates the call queue item TWR-OP3
Then HMI OP3 has in the call queue a number of 0 calls
Then HMI OP1 has in the call queue a number of 0 calls

Scenario: Cleanup - OP2 changes its layout grid tab back
When HMI OP2 with layout <<LAYOUT_MISSION2>> selects grid tab 1

Scenario: A scenario that is only executed in case of an execution failure
Meta: @RunOnFailure
GivenStories: voice_GG/ui/includes/@CleanupStory.story
Then waiting until the cleanup is done
