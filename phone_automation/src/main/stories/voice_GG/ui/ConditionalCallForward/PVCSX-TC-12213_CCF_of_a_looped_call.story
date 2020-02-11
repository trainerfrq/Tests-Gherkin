Meta:
@TEST_CASE_VERSION: V3
@TEST_CASE_NAME: CCF of a looped call
@TEST_CASE_DESCRIPTION: As an operator having set 2 Conditional Call Forward rules that forward a matching call from one to the other for 5 times
I want to establish a call that activates a rule
So I can verify that call is forwarded between the rules for 5 times
@TEST_CASE_PRECONDITION: Settings:
Two missions APP and SUP-TWR have a single role assigned called APP, respectively SUP-TWR with:
| Parameter                     | APP            | SUP-TWR    |
| - - - - - - - - - - - - - - - | - - - - -- -  -|- - - - -   |
| Call Route Selector           | admin          | default    |
| Destination                   | 507723         | 507774     |

Two Conditional Call Forward rules with the following parameters:
| Parameter                    |  Rule 1               |  Rule 2             |
| - - - - - - - - - - - - - - -| - - - - - - -- - --   | - - - - - - - - -   |
| filter Destination type      | Call Route Selector   | SIP URI             |
| Call destination             | admin                 | 50777*@example.com  |
| Out of Service               | no forwarding         | no forwarding       |
| Reject                       | SUP-TWR               | no forwarding       |
| No reply                     | no forwarding         | APP, within: 7 sec  |
| No. of iterations            | 5                     | 0                   |

At the beginning, OP1 has APP role assigned and OP3 has SUP TWR role assigned
@TEST_CASE_PASS_FAIL_CRITERIA: The test is passed if the call is terminated after 5 iterations
@TEST_CASE_DEVICES_IN_USE: OP1, OP2, OP3
@TEST_CASE_ID: PVCSX-TC-12213
@TEST_CASE_GLOBAL_ID: GID-5188041
@TEST_CASE_API_ID: 17979652

Scenario: Booking profiles
Given booked profiles:
| profile | group          | host           | identifier |
| javafx  | hmi            | <<CLIENT1_IP>> | HMI OP1    |
| javafx  | hmi            | <<CLIENT2_IP>> | HMI OP2    |
| javafx  | hmi            | <<CLIENT3_IP>> | HMI OP3    |

Scenario: Define call queue items
Given the call queue items:
| key             | source                     | target                    | callType   |
| ROLE2-APP       | <<ROLE2_URI>>              | sip:999507723@example.com | DA/IDA     |
| APP-ROLE2       | sip:999507723@example.com  |                           | DA/IDA     |

Scenario: OP1 changes its mission to APP
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key MISSIONS
Then HMI OP1 changes current mission to mission <<MISSION_APP_NAME>>
Then HMI OP1 activates mission
Then waiting for 5 seconds

Scenario: OP3 changes its mission to SUP TWR
When HMI OP3 with layout <<LAYOUT_MISSION1>> presses function key MISSIONS
Then HMI OP3 changes current mission to mission <<MISSION_SUP-TWR_NAME>>
Then HMI OP3 activates mission
Then waiting for 5 seconds

Scenario: 1. OP2 establishes a call to APP
Meta:
@TEST_STEP_ACTION: OP2 establishes a call to APP
@TEST_STEP_REACTION: OP2 has a ringing call to APP and OP1 has a call from OP2's master role in the waiting list
@TEST_STEP_REF: [CATS-REF: 50K3]
When HMI OP2 with layout <<LAYOUT_MISSION2>> selects grid tab 3
When HMI OP2 presses DA key APP
Then HMI OP2 has in the call queue a number of 1 calls
Then HMI OP2 has the DA key APP in state out_ringing

Scenario: 1.1 OP1 receives the incoming call
Then HMI OP1 has the call queue item ROLE2-APP in state inc_initiated
Then HMI OP1 has the call queue item ROLE2-APP in the waiting list with name label <<ROLE_2_NAME>>

Scenario: 2. OP1 rejects the call and OP2 waits for 7 seconds
Then HMI OP1 rejects the waiting call queue item from waiting list
Then HMI OP1 has in the call queue a number of 0 calls
Then HMI OP2 has the call queue item APP-ROLE2 in state out_ringing
Then HMI OP2 has the call queue item APP-ROLE2 in the active list with name label <<MISSION_APP_NAME>>
Then HMI OP3 has the call queue item ROLE2-APP in state inc_initiated
Then HMI OP3 has the call queue item ROLE2-APP in the waiting list with name label <<ROLE_2_NAME>>
When waiting for 7 seconds
Then HMI OP3 has in the call queue a number of 0 calls
Then HMI OP2 has the call queue item APP-ROLE2 in state out_ringing
Then HMI OP2 has the call queue item APP-ROLE2 in the active list with name label <<MISSION_APP_NAME>>
Then HMI OP1 has the call queue item ROLE2-APP in state inc_initiated
Then HMI OP1 has the call queue item ROLE2-APP in the waiting list with name label <<ROLE_2_NAME>>

Examples:
| Iteration number |
| 1                |
| 2                |
| 3                |

Scenario: 3. OP1 rejects the call
Meta:
@TEST_STEP_ACTION: OP1 rejects the call
@TEST_STEP_REACTION: The call is terminated for both OP2 and OP1
@TEST_STEP_REF: [CATS-REF: hA4o]
Then HMI OP1 rejects the waiting call queue item from waiting list
Then HMI OP1 has in the call queue a number of 0 calls
Then HMI OP2 has the call queue item APP-ROLE2 in state out_failed

Scenario: Cleanup - OP2 changes its layout grid tab back and cleans the calls queue
When HMI OP2 with layout <<LAYOUT_MISSION2>> selects grid tab 1
Then HMI OP2 presses item 1 from active call queue list
Then HMI OP2 has in the call queue a number of 0 calls
Then HMI OP1 has in the call queue a number of 0 calls

Scenario: Cleanup - OP1 changes its mission back
When HMI OP1 with layout <<LAYOUT_APP>> presses function key MISSIONS
Then HMI OP1 changes current mission to mission <<MISSION_1_NAME>>
Then HMI OP1 activates mission
Then waiting for 5 seconds

Scenario: Cleanup - OP3 changes its mission back
When HMI OP3 with layout <<LAYOUT_SUP-TWR>> presses function key MISSIONS
Then HMI OP3 changes current mission to mission <<MISSION_3_NAME>>
Then HMI OP3 activates mission
Then waiting for 5 seconds

Scenario: A scenario that is only executed in case of an execution failure
Meta: @RunOnFailure
GivenStories: voice_GG/ui/includes/@CleanupStory.story
Then waiting until the cleanup is done
