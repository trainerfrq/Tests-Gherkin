Meta:
@TEST_CASE_VERSION: V9
@TEST_CASE_NAME: CCF forwarding again unsuccessful forwarded call
@TEST_CASE_DESCRIPTION: As an operator having set a Conditional Call Forward rule with number of rule iterations 1
and forward condition of this rule, matches call destination of Conditional Call Forward rule number 2
I want to establish a call that activates the first rule
So I can verify that the call is forwarded according to the second rule forwarding conditions
@TEST_CASE_PRECONDITION: Settings:
Mission GND will have a single role assigned called GND
4 Conditional Call Forward Rules with the following parameters:

| Parameter           |  Rule 1            |  Rule 2          |  Rule 3            |  Rule 4          |
| - - - - - - - - - - | - - - - - - - -  - | - - - - - - - -- | - - - - - - - -  - | - - -- - - - -- -|
| Call destination    | GND                | Phonebook_entry  | Phonebook_entry    | Phonebook_entry  |
| Out of Service      | no forwarding      | skip rule        | OP3                | OP1              |
| Reject              | Phonebook_entry    | no forwarding    | no forwarding      | no forwarding    |
| No reply            | no forwarding      | skip rule        | no forwarding      | no forwarding    |
| No. of iterations   | 1                  | 0                | 0                  | 0                |

OP1 will have the GND mission assigned.
Phonebook_entry <example: sip:134656@example.com> is Out of Service
@TEST_CASE_PASS_FAIL_CRITERIA: The test is passed if OP3 will receive the call
@TEST_CASE_DEVICES_IN_USE: OP1, OP2, OP3
@TEST_CASE_ID: PVCSX-TC-11959
@TEST_CASE_GLOBAL_ID: GID-5165825
@TEST_CASE_API_ID: 17778607

Scenario: Booking profiles
Given booked profiles:
| profile | group          | host           | identifier |
| javafx  | hmi            | <<CLIENT1_IP>> | HMI OP1    |
| javafx  | hmi            | <<CLIENT2_IP>> | HMI OP2    |
| javafx  | hmi            | <<CLIENT3_IP>> | HMI OP3    |
| voip    | <<systemName>> | <<CO3_IP>>     | VOIP       |

Scenario: Define call queue items
Given the call queue items:
| key       | source                 | target                  | callType |
| GND-ROLE2 | sip:507722@example.com |                         | DA/IDA   |
| ROLE2-GND | <<ROLE2_URI>>          | sip:507722@example.com  | DA/IDA   |

Scenario: OP1 changes its mission to GND
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key MISSIONS
Then HMI OP1 changes current mission to mission <<MISSION_GND_NAME>>
Then HMI OP1 activates mission
Then waiting for 5 seconds

Scenario: 1. OP2 establishes a call to GND
Meta:
@TEST_STEP_ACTION: OP2 establishes a call to GND
@TEST_STEP_REACTION: OP2 has a ringing call to GND and OP1 has a call from OP2's master role in the waiting list
@TEST_STEP_REF: [CATS-REF: qZQn]
When HMI OP2 with layout <<LAYOUT_MISSION2>> selects grid tab 3
When HMI OP2 presses DA key GND
Then HMI OP2 has the call queue item GND-ROLE2 in state out_ringing

Scenario: 1.1 OP1 receives the call
Then HMI OP1 has the call queue item ROLE2-GND in state inc_initiated

Scenario: 1.2 Verifying call queue section
Then HMI OP2 has the call queue item GND-ROLE2 in the active list with name label <<MISSION_GND_NAME>>
Then HMI OP1 has the call queue item ROLE2-GND in the waiting list with name label <<ROLE_2_NAME>>

Scenario: 2. OP1 rejects the call
Meta:
@TEST_STEP_ACTION: OP1 rejects the call
@TEST_STEP_REACTION: OP2 has a ringing call to GND and the call is forwarded to phonebook_entry_1. The call will be forwarded again due to skip condition.
@TEST_STEP_REF: [CATS-REF: qplp]
Then HMI OP1 rejects the waiting call queue item from waiting list
Then HMI OP1 has in the call queue a number of 0 calls

Scenario: 2.1 OP2 still has a ringing call
Then HMI OP2 has the call queue item GND-ROLE2 in state out_ringing

Scenario: 3. OP3 verifies call queue section
Meta:
@TEST_STEP_ACTION: OP3 verifies call queue section
@TEST_STEP_REACTION: Because phonebook_entry_1 is Out of Service and number of iterations was not decremented, OP2 has a ringing call to GND and OP3 has a call from OP2's master role in the waiting list.
@TEST_STEP_REF: [CATS-REF: cN9M]
Then HMI OP3 has the call queue item ROLE2-GND in state inc_initiated
Then HMI OP3 has the call queue item ROLE2-GND in the waiting list with name label <<ROLE_2_NAME>>

Scenario: 4. OP1 verifies call queue section
Meta:
@TEST_STEP_ACTION: OP1 verifies call queue section
@TEST_STEP_REACTION: OP1 has no calls in queue, because rule 3) was activated before rule 4)
@TEST_STEP_REF: [CATS-REF: tEhB]
Then HMI OP1 has in the call queue a number of 0 calls

Scenario: 5. OP2 terminates the call
Meta:
@TEST_STEP_ACTION: OP2 terminates the call
@TEST_STEP_REACTION: The call is terminated for both OP2 and OP3
@TEST_STEP_REF: [CATS-REF: KTxj]
When HMI OP2 presses DA key GND
Then HMI OP2 has in the call queue a number of 0 calls
Then HMI OP3 has in the call queue a number of 0 calls
Then HMI OP1 has in the call queue a number of 0 calls

Scenario: Cleanup - OP1 changes its mission back
When HMI OP1 with layout <<COMMON_LAYOUT>> presses function key MISSIONS
Then HMI OP1 changes current mission to mission <<MISSION_1_NAME>>
Then HMI OP1 activates mission
Then waiting for 5 seconds

Scenario: Cleanup - OP2 changes its layout grid tab back
When HMI OP2 with layout <<LAYOUT_MISSION2>> selects grid tab 1

Scenario: A scenario that is only executed in case of an execution failure
Meta: @RunOnFailure
GivenStories: voice_GG/ui/includes/@CleanupStory.story
Then waiting until the cleanup is done
