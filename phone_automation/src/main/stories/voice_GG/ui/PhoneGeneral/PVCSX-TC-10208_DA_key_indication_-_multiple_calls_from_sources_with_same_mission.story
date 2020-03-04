Meta:
@TEST_CASE_VERSION: V4
@TEST_CASE_NAME: DA key indication - multiple calls from sources with same mission
@TEST_CASE_DESCRIPTION: 
As an operator having a DA key configured with Call to: Mission2
I want to receive calls from Mission2 (assigned to more operators) and pass them through different states
So I can verify that DA key's state is displayed according to the call's state
@TEST_CASE_PRECONDITION: 
- OP1 has Mission1 active
- OP1 has DA key for Mission2 configured on the layout
- OP2 and OP3 have Mission2 active
@TEST_CASE_PASS_FAIL_CRITERIA: 
This test is passed when the operator position handles the indication on the DA-key, in case of multiple calls coming from sources with same mission, such as displaying indications for the following states of a call:
1) Active call
2) Pending call (longest pending duration)
3) Call on hold (longest inactivity duration)
@TEST_CASE_DEVICES_IN_USE: 
OP1:
OP2:
OP3:
@TEST_CASE_ID: PVCSX-TC-10208
@TEST_CASE_GLOBAL_ID: GID-4797851
@TEST_CASE_API_ID: 15009928

Scenario: Booking profiles
Given booked profiles:
| profile | group | host           | identifier |
| javafx  | hmi   | <<CLIENT1_IP>> | HMI OP1    |
| javafx  | hmi   | <<CLIENT2_IP>> | HMI OP2    |
| javafx  | hmi   | <<CLIENT3_IP>> | HMI OP3    |

Scenario: Define call queue items
Given the call queue items:
| key       | source        | target        | callType |
| OP1-ROLE2 | <<OP1_URI>>   |               | DA/IDA   |
| ROLE2-OP1 | <<ROLE2_URI>> | <<OP1_URI>>   | DA/IDA   |

Scenario: OP3 changes its mission to MISSION_2
When HMI OP3 with layout <<LAYOUT_MISSION3>> presses function key MISSIONS
Then HMI OP3 changes current mission to mission <<MISSION_2_NAME>>
Then HMI OP3 activates mission
Then waiting for 5 seconds

Scenario: 1. OP2: Set up an active call to OP1
Meta:
@TEST_STEP_ACTION: OP2: Set up an active call to OP1
@TEST_STEP_REACTION: OP1 and OP2 have an active call
@TEST_STEP_REF: [CATS-REF: aGZn]
When HMI OP2 presses DA key OP1(as Mission2)
Then HMI OP2 has in the active list the call queue item OP1-ROLE2 with state out_ringing

Scenario: 1.1 OP1 receives the call
Then HMI OP1 has in the waiting list the call queue item ROLE2-OP1 with state inc_initiated

Scenario: 1.2 Verifying call queue section
Then HMI OP2 has the call queue item OP1-ROLE2 in the active list with name label <<OP1_NAME>>
Then HMI OP1 has the call queue item ROLE2-OP1 in the waiting list with name label <<ROLE_2_NAME>>

Scenario: 1.3 OP1 accepts the call
When HMI OP1 presses DA key <<ROLE_2_NAME>>
Then HMI OP1 has in the call queue a number of 1 calls
Then HMI OP2 has in the call queue a number of 1 calls
Then HMI OP1 has in the active list the call queue item ROLE2-OP1 with state connected
Then HMI OP2 has in the active list the call queue item OP1-ROLE2 with state connected

Scenario: 1.4 OP1 checks configured DA key state
Meta:
@TEST_STEP_ACTION: -
@TEST_STEP_REACTION: OP1: DA key of Mission2 is indicating active call
@TEST_STEP_REF: [CATS-REF: ctJg]
Then HMI OP1 has the DA key <<ROLE_2_NAME>> in state connected

Scenario: 2. OP3: Set up a call to OP1
Meta:
@TEST_STEP_ACTION: OP3: Set up a call to OP1
@TEST_STEP_REACTION: OP1 has an indication of a pending call, from OP3's master role, in call queue
@TEST_STEP_REF: [CATS-REF: 4YRF]
When HMI OP3 presses DA key OP1(as Mission2)
Then HMI OP3 has in the active list the call queue item OP1-ROLE2 with state out_ringing

Scenario: 2.1 OP1 receives the call from OP3
Then HMI OP1 has in the waiting list the call queue item ROLE2-OP1 with state inc_initiated

Scenario: 2.2 OP1 still has the active call with OP2
Then HMI OP1 has in the active list the call queue item ROLE2-OP1 with state connected

Scenario: 2.3 Verifying call queue section
Then HMI OP3 has the call queue item OP1-ROLE2 in the active list with name label <<OP1_NAME>>
Then HMI OP1 has the call queue item ROLE2-OP1 in the waiting list with name label <<ROLE_2_NAME>>
Then HMI OP1 has the call queue item ROLE2-OP1 in the active list with name label <<ROLE_2_NAME>>

Scenario: 2.4 OP1 checks configured DA key state
Meta:
@TEST_STEP_ACTION: -
@TEST_STEP_REACTION: OP1: DA key of Mission2 still indicating active call
@TEST_STEP_REF: [CATS-REF: iuma]
Then HMI OP1 has the DA key <<ROLE_2_NAME>> in state connected

Scenario: 3. OP1: Set active call with OP2 on hold
Meta:
@TEST_STEP_ACTION: OP1: Set active call with OP2 on hold
@TEST_STEP_REACTION: Call with OP2 is indicated as on hold in call queue
@TEST_STEP_REF: [CATS-REF: PeC5]
When HMI OP1 puts on hold the active call
Then HMI OP1 has in the hold list the call queue item ROLE2-OP1 with state hold
Then HMI OP1 has in the waiting list the call queue item ROLE2-OP1 with state inc_initiated
Then HMI OP2 has in the active list the call queue item OP1-ROLE2 with state held

Scenario: 3.1 OP1 checks configured DA key state
Meta:
@TEST_STEP_ACTION: -
@TEST_STEP_REACTION: OP1: DA key of Mission2 is indicated as incoming pending call (from OP3)
@TEST_STEP_REF: [CATS-REF: eIAV]
Then HMI OP1 has the DA key <<ROLE_2_NAME>> in state inc_initiated

Scenario: 4. OP1: Terminate all calls
Meta:
@TEST_STEP_ACTION: OP1: Terminate all calls
@TEST_STEP_REACTION: All calls terminated
@TEST_STEP_REF: [CATS-REF: egYh]
When HMI OP1 presses DA key <<ROLE_2_NAME>>
Then HMI OP1 has in the active list the call queue item ROLE2-OP1 with state connected
Then HMI OP2 has in the active list the call queue item OP1-ROLE2 with state held
Then HMI OP3 has in the active list the call queue item OP1-ROLE2 with state connected

Scenario: 4.1 OP1 retrieves call from hold, terminating the active call
Then HMI OP1 retrieves from hold the call queue item ROLE2-OP1
Then HMI OP1 has in the active list the call queue item ROLE2-OP1 with state connected
Then HMI OP2 has in the active list the call queue item OP1-ROLE2 with state connected
Then HMI OP3 has in the call queue a number of 0 calls

Scenario: 4.2 OP1 terminates the active call
Then HMI OP1 terminates the call queue item ROLE2-OP1
Then HMI OP1 has in the call queue a number of 0 calls
Then HMI OP2 has in the call queue a number of 0 calls

Scenario: Cleanup - OP3 changes its mission back
When HMI OP3 with layout <<LAYOUT_MISSION2>> presses function key MISSIONS
Then HMI OP3 changes current mission to mission <<MISSION_3_NAME>>
Then HMI OP3 activates mission
Then waiting for 5 seconds

Scenario: A scenario that is only executed in case of an execution failure
Meta: @RunOnFailure
GivenStories: voice_GG/ui/includes/@CleanupStory.story
Then waiting until the cleanup is done
