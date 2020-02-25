Meta:
@TEST_CASE_VERSION: V5
@TEST_CASE_NAME: CCF test with max number of CCF rules
@TEST_CASE_DESCRIPTION: As an operator having set 20 Conditional Call Forward rules
I want to establish calls
So I can verify that the rules are activated
@TEST_CASE_PRECONDITION: Settings:
Mission GND has only Role GND assigned

20 Conditional Call Forward rules with the following parameters:
| Parameter            | Rule 1            | Rules 2-19        | Rule 20           | Rule 21              |
|----------------------|-------------------|-------------------|-------------------|----------------------|
| Call destination     | GND               | Phonebook_entry   | Phonebook_entry   | A warning message is |
| Out of Service       | no forwarding     | skip rule         | OP3               | displayed, when      |
| Reject               | Phonebook_entry   | no forwarding     | no forwarding     | trying to add        |
| No reply             | no forwarding     | no forwarding     | no forwarding     | the 21th rule        |
| No. of iterations    | 1                 | 0                 | 0                 |                      |

OP1 has the GND mission assigned.
Phonebook_entry <example: sip:134656@example.com> is Out of Service
@TEST_CASE_PASS_FAIL_CRITERIA: This test is passed when it is possible to configure up to 20 Conditional Call Forward rules and each call matching a destination will be forwarded as configured
@TEST_CASE_DEVICES_IN_USE: OP1, OP2, OP3
@TEST_CASE_ID: PVCSX-TC-12483
@TEST_CASE_GLOBAL_ID: GID-5210234
@TEST_CASE_API_ID: 18167672

Scenario: Booking profiles
Given booked profiles:
| profile | group          | host           | identifier |
| javafx  | hmi            | <<CLIENT1_IP>> | HMI OP1    |
| javafx  | hmi            | <<CLIENT2_IP>> | HMI OP2    |
| javafx  | hmi            | <<CLIENT3_IP>> | HMI OP3    |

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
@TEST_STEP_REF: [CATS-REF: irRN]
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
@TEST_STEP_REACTION: OP2 has a ringing call to GND and the call is forwarded to Phonebook_entry. The call will be forwarded again 18 times, due to skip condition
@TEST_STEP_REF: [CATS-REF: FnqU]
Then HMI OP1 rejects the waiting call queue item from waiting list
Then HMI OP1 has in the call queue a number of 0 calls

Scenario: 2.1 OP2 still has a ringing call
Then HMI OP2 has the call queue item GND-ROLE2 in state out_ringing

Scenario: 3. OP1 verifies call queue section
Meta:
@TEST_STEP_ACTION: OP1 verifies call queue section
@TEST_STEP_REACTION: OP2 has a ringing call to GND and OP1 has no more calls in queue
@TEST_STEP_REF: [CATS-REF: yzmN]
Then HMI OP2 has the call queue item GND-ROLE2 in state out_ringing
Then HMI OP2 has the call queue item GND-ROLE2 in the active list with name label <<MISSION_GND_NAME>>
Then HMI OP1 has in the call queue a number of 0 calls

Scenario: 4. OP3 verifies call queue section
Meta:
@TEST_STEP_ACTION: OP3 verifies call queue section
@TEST_STEP_REACTION: OP2 has a ringing call to GND and OP3 has a call from OP2's master role in the waiting list
@TEST_STEP_REF: [CATS-REF: eYL6]
Then HMI OP2 has the call queue item GND-ROLE2 in state out_ringing
Then HMI OP2 has the call queue item GND-ROLE2 in the active list with name label <<MISSION_GND_NAME>>

Scenario: 4.1 OP3 has a call from OP2's master role
Then HMI OP3 has the call queue item ROLE2-GND in state inc_initiated
Then HMI OP3 has the call queue item ROLE2-GND in the waiting list with name label <<ROLE_2_NAME>>

Scenario: 5. OP2 terminates the call
Meta:
@TEST_STEP_ACTION: OP2 terminates the call
@TEST_STEP_REACTION: The call is terminated for both OP2 and OP3
@TEST_STEP_REF: [CATS-REF: ZXNw]
When HMI OP2 presses DA key GND
Then HMI OP2 has in the call queue a number of 0 calls
Then HMI OP3 has in the call queue a number of 0 calls

Scenario: Cleanup - OP1 changes its mission back
When HMI OP1 with layout <<LAYOUT_GND>> presses function key MISSIONS
Then HMI OP1 changes current mission to mission <<MISSION_1_NAME>>
Then HMI OP1 activates mission
Then waiting for 5 seconds

Scenario: Cleanup - OP2 changes its layout grid tab back
When HMI OP2 with layout <<LAYOUT_MISSION2>> selects grid tab 1

Scenario: A scenario that is only executed in case of an execution failure
Meta: @RunOnFailure
GivenStories: voice_GG/ui/includes/@CleanupStory.story
Then waiting until the cleanup is done
