Meta:
@TEST_CASE_VERSION: V10
@TEST_CASE_NAME: CCF of Priority calls
@TEST_CASE_DESCRIPTION: As an operator having a Conditional Call Forward Rule set with different destinations for each forward condition
I want to establish priority calls that activate the rule and fits each forward condition
So I can verify that the call will be forwarded with respect to matching condition
@TEST_CASE_PRECONDITION: Mission TWR has only Role TWR assigned
Settings:
A Conditional Call Forward rule is set with:
- matching call destination: TWR
- forward calls on:                           *out of service: OP1                           *reject: OP3                           *no reply: OP3, within 20 seconds
-number of rule iterations: 0
None of the operators have TWR role assigned.
@TEST_CASE_PASS_FAIL_CRITERIA: The test is passed when it is possible to configure a Conditional Call Forward rule with different destinations for each forward condition and each priority call matching the rule is forwarded as configured.
@TEST_CASE_DEVICES_IN_USE: OP1, OP2, OP3
@TEST_CASE_ID: PVCSX-TC-12050
@TEST_CASE_GLOBAL_ID: GID-5174778
@TEST_CASE_API_ID: 17861537

Scenario: Booking profiles
Given booked profiles:
| profile | group          | host           | identifier |
| javafx  | hmi            | <<CLIENT1_IP>> | HMI OP1    |
| javafx  | hmi            | <<CLIENT2_IP>> | HMI OP2    |
| javafx  | hmi            | <<CLIENT3_IP>> | HMI OP3    |

Scenario: Define call queue items
Given the call queue items:
| key       | source                 | target                  | callType |
| TWR-ROLE2 | sip:507721@example.com |                         | DA/IDA   |
| ROLE2-TWR | <<ROLE2_URI>>          | sip:507721@example.com  | DA/IDA   |

Scenario: 1. OP2 establishes a priority call to TWR
Meta:
@TEST_STEP_ACTION: OP2 establishes a priority call to TWR
@TEST_STEP_REACTION: OP2 has a priority ringing call to TWR and OP1 has a priority call from OP2's master role in the priority list
@TEST_STEP_REF: [CATS-REF: tGIR]
When HMI OP2 with layout <<LAYOUT_MISSION2>> selects grid tab 3
When HMI OP2 initiates a priority call on DA key TWR
Then HMI OP2 has the call queue item TWR-ROLE2 in state out_ringing
Then HMI OP2 has in the call queue the item TWR-ROLE2 with priority
Then HMI OP2 has the call queue item TWR-ROLE2 in the active list with name label <<MISSION_TWR_NAME>>

Scenario: 1.1 OP1 receives the call
Then HMI OP1 has the call queue item ROLE2-TWR in state inc_initiated
Then HMI OP1 has in the call queue the item ROLE2-TWR with priority
Then HMI OP1 has the call queue item ROLE2-TWR in the priority list with name label <<ROLE_2_NAME>>

Scenario: 2. OP1 accepts the call
Meta: @TEST_STEP_ACTION: OP1 accepts the call
@TEST_STEP_REACTION: The call is connected for both OP2 and OP1
@TEST_STEP_REF: [CATS-REF: pO1h]
Then HMI OP1 accepts the call queue item ROLE2-TWR
Then HMI OP1 has in the call queue a number of 1 calls
Then HMI OP2 has in the call queue a number of 1 calls

Scenario: 2.1 Verifying call queue section
Then HMI OP2 has the call queue item TWR-ROLE2 in state connected
Then HMI OP2 has in the call queue the item TWR-ROLE2 with priority
Then HMI OP2 has the call queue item TWR-ROLE2 in the active list with name label <<MISSION_TWR_NAME>>
Then HMI OP1 has the call queue item ROLE2-TWR in state connected
Then HMI OP1 has in the call queue the item ROLE2-TWR with priority
Then HMI OP1 has the call queue item ROLE2-TWR in the active list with name label <<ROLE_2_NAME>>

Scenario: 3. OP2 terminates the call
Meta:
@TEST_STEP_ACTION: OP2 terminates the call
@TEST_STEP_REACTION: The call is terminated for both OP2 and OP1
@TEST_STEP_REF: [CATS-REF: 2dLG]
When HMI OP2 presses DA key TWR
Then HMI OP2 has in the call queue a number of 0 calls
Then HMI OP1 has in the call queue a number of 0 calls

Scenario: 4. OP1 changes its mission to TWR
Meta:
@TEST_STEP_ACTION: OP1 changes its mission to TWR
@TEST_STEP_REACTION: OP1 has TWR mission assigned
@TEST_STEP_REF: [CATS-REF: 0QTD]
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key MISSIONS
Then HMI OP1 changes current mission to mission <<MISSION_TWR_NAME>>
Then HMI OP1 activates mission
Then waiting for 5 seconds

Scenario: 4.1 Verify operator mission
Then HMI OP1 has in the DISPLAY STATUS TWR section mission the assigned mission <<MISSION_TWR_NAME>>

Scenario: 5. OP2 establishes a priority call to TWR
Meta:
@TEST_STEP_ACTION: OP2 establishes a priority call to TWR
@TEST_STEP_REACTION: OP2 has a priority ringing call to TWR and OP1 has a priority call from OP2's master role in the priority list
@TEST_STEP_REF: [CATS-REF: qxff]
When HMI OP2 initiates a priority call on DA key TWR
Then HMI OP2 has the call queue item TWR-ROLE2 in state out_ringing
Then HMI OP2 has in the call queue the item TWR-ROLE2 with priority
Then HMI OP2 has the call queue item TWR-ROLE2 in the active list with name label <<MISSION_TWR_NAME>>

Scenario: 5.1 OP1 receives the call
Then HMI OP1 has the call queue item ROLE2-TWR in state inc_initiated
Then HMI OP1 has in the call queue the item ROLE2-TWR with priority
Then HMI OP1 has the call queue item ROLE2-TWR in the priority list with name label <<ROLE_2_NAME>>

Scenario: 6. OP1 rejects the call
Meta:
@TEST_STEP_ACTION: OP1 rejects the call
@TEST_STEP_REACTION: OP2 has a priority ringing call to TWR and OP3 has a priority call from OP2's master role in the priority list
@TEST_STEP_REF: [CATS-REF: buCF]
Then HMI OP1 rejects the waiting call queue item from priority list
Then HMI OP1 has in the call queue a number of 0 calls

Scenario: 6.1 OP2 still has a ringing call
Then HMI OP2 has the call queue item TWR-ROLE2 in state out_ringing
Then HMI OP2 has in the call queue the item TWR-ROLE2 with priority

Scenario: 6.2 OP3 receives the call
Then HMI OP3 has the call queue item ROLE2-TWR in state inc_initiated
Then HMI OP3 has in the call queue the item ROLE2-TWR with priority
Then HMI OP3 has the call queue item ROLE2-TWR in the priority list with name label <<ROLE_2_NAME>>

Scenario: 7. OP3 accepts the call
Meta: @TEST_STEP_ACTION: OP3 accepts the call
@TEST_STEP_REACTION: The call is connected for both OP2 and OP3
@TEST_STEP_REF: [CATS-REF: z9o3]
Then HMI OP3 accepts the call queue item ROLE2-TWR
Then HMI OP3 has in the call queue a number of 1 calls
Then HMI OP2 has in the call queue a number of 1 calls

Scenario: 7.1 Verifying call queue section
Then HMI OP2 has the call queue item TWR-ROLE2 in state connected
Then HMI OP2 has in the call queue the item TWR-ROLE2 with priority
Then HMI OP2 has the call queue item TWR-ROLE2 in the active list with name label <<MISSION_TWR_NAME>>
Then HMI OP3 has the call queue item ROLE2-TWR in state connected
Then HMI OP3 has in the call queue the item ROLE2-TWR with priority
Then HMI OP3 has the call queue item ROLE2-TWR in the active list with name label <<ROLE_2_NAME>>

Scenario: 8. OP2 terminates the call
Meta:
@TEST_STEP_ACTION: OP2 terminates the call
@TEST_STEP_REACTION: The call is terminated for both OP2 and OP3
@TEST_STEP_REF: [CATS-REF: ybGi]
When HMI OP2 presses DA key TWR
Then HMI OP2 has in the call queue a number of 0 calls
Then HMI OP3 has in the call queue a number of 0 calls

Scenario: 9. OP2 establishes a priority call to TWR
Meta:
@TEST_STEP_ACTION: OP2 establishes a priority call to TWR
@TEST_STEP_REACTION: OP2 has a priority ringing call to TWR and OP1 has a priority call from OP2's master role in the priority list
@TEST_STEP_REF: [CATS-REF: ozgq]
When HMI OP2 initiates a priority call on DA key TWR
Then HMI OP2 has the call queue item TWR-ROLE2 in state out_ringing
Then HMI OP2 has in the call queue the item TWR-ROLE2 with priority
Then HMI OP2 has the call queue item TWR-ROLE2 in the active list with name label <<MISSION_TWR_NAME>>

Scenario: 9.1 OP1 receives the call
Then HMI OP1 has the call queue item ROLE2-TWR in state inc_initiated
Then HMI OP1 has in the call queue the item ROLE2-TWR with priority
Then HMI OP1 has the call queue item ROLE2-TWR in the priority list with name label <<ROLE_2_NAME>>

Scenario: 10. OP2 is waiting for 20 seconds
Meta:
@TEST_STEP_ACTION: OP2 is waiting for 20 seconds
@TEST_STEP_REACTION: OP2 has a priority ringing call to TWR, the call is terminated for OP1 and OP3 has a priority call from OP2's master role in the priority list
@TEST_STEP_REF: [CATS-REF: 8qIU]
When waiting for 20 seconds
Then HMI OP2 has the call queue item TWR-ROLE2 in state out_ringing
Then HMI OP2 has in the call queue the item TWR-ROLE2 with priority
Then HMI OP2 has the call queue item TWR-ROLE2 in the active list with name label <<MISSION_TWR_NAME>>

Scenario: 10.1 OP1 has no calls in queue
Then HMI OP1 has in the call queue a number of 0 calls

Scenario: 10.2 OP3 verifies its calls queue section
Then HMI OP3 has the call queue item ROLE2-TWR in state inc_initiated
Then HMI OP3 has in the call queue the item ROLE2-TWR with priority
Then HMI OP3 has the call queue item ROLE2-TWR in the priority list with name label <<ROLE_2_NAME>>

Scenario: 11. OP3 accepts the call
Meta: @TEST_STEP_ACTION: OP3 accepts the call
@TEST_STEP_REACTION: The call is connected for both OP2 and OP3
@TEST_STEP_REF: [CATS-REF: z9o3]
Then HMI OP3 accepts the call queue item ROLE2-TWR
Then HMI OP3 has in the call queue a number of 1 calls
Then HMI OP2 has in the call queue a number of 1 calls

Scenario: 11.1 Verifying call queue section
Then HMI OP2 has the call queue item TWR-ROLE2 in state connected
Then HMI OP2 has in the call queue the item TWR-ROLE2 with priority
Then HMI OP2 has the call queue item TWR-ROLE2 in the active list with name label <<MISSION_TWR_NAME>>
Then HMI OP3 has the call queue item ROLE2-TWR in state connected
Then HMI OP3 has in the call queue the item ROLE2-TWR with priority
Then HMI OP3 has the call queue item ROLE2-TWR in the active list with name label <<ROLE_2_NAME>>

Scenario: 12. OP2 terminates the call
Meta:
@TEST_STEP_ACTION: OP2 terminates the call
@TEST_STEP_REACTION: The call is terminated for both OP2 and OP3
@TEST_STEP_REF: [CATS-REF: AA1W]
When HMI OP2 presses DA key TWR
Then HMI OP2 has in the call queue a number of 0 calls
Then HMI OP3 has in the call queue a number of 0 calls

Scenario: Cleanup - OP1 changes its mission back
When HMI OP1 with layout <<LAYOUT_TWR>> presses function key MISSIONS
Then HMI OP1 changes current mission to mission <<MISSION_1_NAME>>
Then HMI OP1 activates mission
Then waiting for 5 seconds

Scenario: Cleanup - OP2 changes its layout grid tab back
When HMI OP2 with layout <<LAYOUT_MISSION2>> selects grid tab 1

Scenario: A scenario that is only executed in case of an execution failure
Meta: @RunOnFailure
GivenStories: voice_GG/ui/includes/@CleanupStory.story
Then waiting until the cleanup is done

