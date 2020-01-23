Meta:
@TEST_CASE_VERSION: V2
@TEST_CASE_NAME: CCF with IA call
@TEST_CASE_DESCRIPTION: As an operator having set a Conditional Call Forward rule
I want to establish an IA call
So i can verify that the call is forwarded according to the rule
@TEST_CASE_PRECONDITION: A mission TWR has a single role assigned called TWR
Settings:
A Conditional Call Forward with:
- matching call destinations: TWR
- forward calls on:                           *out of service: OP1                           *reject: no call forwarding                           *no reply: no call forwarding
- number of rule iterations: 0
OP1 has a role assigned with:
- maximum number of incoming IA Calls: 3
OP3 has in its layout a IA key with:
- call to: TWR
- call as: Active Role (Master Role)
None of the operators will have TWR role assigned
@TEST_CASE_PASS_FAIL_CRITERIA: The test is passed if OP1 receives an IA call
@TEST_CASE_DEVICES_IN_USE: OP1, OP3
@TEST_CASE_ID: PVCSX-TC-12090
@TEST_CASE_GLOBAL_ID: GID-5176760
@TEST_CASE_API_ID: 17874896

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
| TWR-GND         | sip:507721@example.com  |                        | IA         |
| TWR-GND-1       | sip:507721@example.com  | sip:507722@example.com | IA         |
| GND-TWR         | sip:507722@example.com  | sip:507721@example.com | IA         |

Scenario: Precondition - OP3 changes its mission to GND
When HMI OP3 with layout <<LAYOUT_MISSION3>> presses function key MISSIONS
Then HMI OP3 changes current mission to mission <<MISSION_GND_NAME>>
Then HMI OP3 activates mission
Then waiting for 5 seconds

Scenario: 1. OP3 presses IA key TWR
Meta:
@TEST_STEP_ACTION: OP3 presses IA key TWR 
@TEST_STEP_REACTION: OP3 has a connected IA call to TWR. Because TWR is Out of Service, OP1 has a connected call from OP3's master role
@TEST_STEP_REF: [CATS-REF: bBgk]
When HMI OP3 with layout <<COMMON_LAYOUT>> selects grid tab 2
When HMI OP3 presses IA key IA - TWR
Then HMI OP3 has the IA key IA - TWR in state connected

Scenario: 1.1 OP3 verifies its calls queue
Then HMI OP3 has the call queue item TWR-GND in state connected
Then HMI OP3 has the call queue item TWR-GND in the active list with name label TWR

Scenario: 1.2 OP1 verifies its calls queue
Then HMI OP1 has the call queue item GND-TWR in state connected
Then HMI OP1 has the call queue item GND-TWR in the active list with name label GND

Scenario: 2. Verifying call's audio direction
Meta:
@TEST_STEP_ACTION: Verifying call directions
@TEST_STEP_REACTION: OP3 has an IA call with audio direction TX and OP1 has an IA call with audio direction RX
@TEST_STEP_REF: [CATS-REF: f4aC]
Then HMI OP3 has the IA call queue item TWR-GND with audio direction tx
Then HMI OP1 has the IA call queue item GND-TWR with audio direction rx

Scenario: 3. OP1 changes active's IA call audio direction by clicking on the active call queue item
Meta:
@TEST_STEP_ACTION: OP1 changes active's IA call audio direction by clicking on the active call queue item
@TEST_STEP_REACTION: OP1 and OP3 have an active IA call with audio direction DUPLEX
@TEST_STEP_REF: [CATS-REF: OxI3]
Then HMI OP1 presses the call queue item GND-TWR
Then HMI OP1 has the call queue item GND-TWR in state connected
Then HMI OP1 has the call queue item GND-TWR in the active list with name label GND

Scenario: 3.1 OP1 verifies call's audio direction
Then HMI OP1 has the IA call queue item GND-TWR with audio direction duplex

Scenario: 3.2 OP3 verifies calls queue section and call's audio direction
Then HMI OP3 has the call queue item TWR-GND-1 in state connected
Then HMI OP3 has the call queue item TWR-GND-1 in the active list with name label TWR
Then HMI OP3 has the IA call queue item TWR-GND-1 with audio direction duplex

Scenario: 4. OP3 terminates the IA call by clicking on the active call queue item
Meta:
@TEST_STEP_ACTION: OP3 terminates the IA call by clicking on the active call queue item
@TEST_STEP_REACTION: OP3 has an active IA call with audio direction RX and OP1 has an active IA call with audio direction TX
@TEST_STEP_REF: [CATS-REF: l0PX]
Then HMI OP3 presses the call queue item TWR-GND-1

Scenario: 4.1 Verifying calls' audio direction
Then HMI OP3 has the IA call queue item TWR-GND-1 with audio direction rx
Then HMI OP1 has the IA call queue item GND-TWR with audio direction tx

Scenario: 5. OP1 terminates the IA call by clicking on the active call queue item
Meta:
@TEST_STEP_ACTION: OP1 terminates the IA call by clicking on the active call queue item
@TEST_STEP_REACTION: The call is terminated for both operators
@TEST_STEP_REF: [CATS-REF: k3K1]
Then HMI OP1 presses the call queue item GND-TWR

Scenario: 5.1 Verifying calls queue section
Then HMI OP1 has in the call queue a number of 0 calls
Then HMI OP3 has in the call queue a number of 0 calls

Scenario: Cleanup - OP3 changes its mission back
When HMI OP3 with layout <<COMMON_LAYOUT>> presses function key MISSIONS
Then HMI OP3 changes current mission to mission <<MISSION_3_NAME>>
Then HMI OP3 activates mission
Then waiting for 5 seconds

Scenario: A scenario that is only executed in case of an execution failure
Meta: @RunOnFailure
GivenStories: voice_GG/ui/includes/@CleanupUICallQueue.story,
			  voice_GG/ui/includes/@CleanupStory.story
Then waiting until the cleanup is done



