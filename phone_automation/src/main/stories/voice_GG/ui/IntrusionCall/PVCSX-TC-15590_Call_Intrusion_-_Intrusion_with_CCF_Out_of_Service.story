Meta:
@TEST_CASE_VERSION: V1
@TEST_CASE_NAME: Call Intrusion - Intrusion with CCF Out of Service
@TEST_CASE_DESCRIPTION: 
GIVEN an operator that has an active DA Call and Call Intrusion set to "Enabled"
AND me as another operator having a Conditional Call Forward rule configured to forward calls to the given operator
I want to initiate an outgoing Priority call that activates the rule
So I can verify that the Priority call intrudes the active call of the given operator
@TEST_CASE_PRECONDITION: 
@TEST_CASE_PASS_FAIL_CRITERIA: 
@TEST_CASE_DEVICES_IN_USE: 
@TEST_CASE_ID: PVCSX-TC-15590
@TEST_CASE_GLOBAL_ID: GID-5601415
@TEST_CASE_API_ID: 19971909

Scenario: Booking profiles
Given booked profiles:
| profile | group | host           | identifier |
| javafx  | hmi   | <<CLIENT1_IP>> | HMI OP1    |
| javafx  | hmi   | <<CLIENT2_IP>> | HMI OP2    |
| javafx  | hmi   | <<CLIENT3_IP>> | HMI OP3    |

Scenario: Define call queue items
Given the call queue items:
| key       | source                 | target                 | callType  |
| OP1-OP2   | <<OP1_URI>>            | <<OP2_URI>>            | DA/IDA    |
| OP2-OP1   | <<OP2_URI>>            | <<OP1_URI>>            | DA/IDA    |
| ROLE3-TWR | <<ROLE3_URI>>          | sip:507721@example.com |  DA/IDA   |
| TWR-ROLE3 | sip:507721@example.com |                        |  DA/IDA   |

Scenario: OP1 changes its mission to GND
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key MISSIONS
Then HMI OP1 changes current mission to mission <<MISSION_GND_NAME>>
Then HMI OP1 activates mission
Then waiting for 5 seconds

Scenario: OP1: Set up an active DA call to OP2
When HMI OP1 presses DA key OP2(as GND)
Then HMI OP1 has the DA key OP2(as GND) in state out_ringing
Then HMI OP1 has the call queue item OP2-OP1 in state out_ringing

Scenario: OP2 receives the incoming call
Then HMI OP2 has the call queue item OP1-OP2 in state inc_initiated

Scenario: OP2 answers the incoming call
When HMI OP2 presses DA key OP1

Scenario: Verify call is connected for both operators
Then HMI OP1 has the call queue item OP2-OP1 in state connected
Then HMI OP2 has the call queue item OP1-OP2 in state connected

Scenario: OP3: Establish a priority call to TWR
When HMI OP3 with layout <<LAYOUT_MISSION3>> selects grid tab 3
When HMI OP3 initiates a priority call on DA key <<MISSION_TWR_NAME>>
Then HMI OP3 has the DA key TWR in state out_ringing

Scenario: OP1 receives the incoming priority call
Then HMI OP1 has in the call queue a number of 2 calls
Then HMI OP1 has the call queue item ROLE3-TWR in state inc_ringing

Scenario: Verify call queue section
Then HMI OP1 has in the call queue the item ROLE3-TWR with priority
Then HMI OP1 has the call queue item ROLE3-TWR in the priority list with name label <<ROLE_3_NAME>>
Then HMI OP3 has in the call queue the item TWR-ROLE3 with priority
Then HMI OP3 has the call queue item TWR-ROLE3 in the active list with name label <<MISSION_TWR_NAME>>

Scenario: Verify Notification Display
When HMI OP1 opens Notification Display list
Then HMI OP1 verifies that list State contains on position 0 text Call Intrusion In Progress ...

Scenario: Close popup window
Then HMI OP1 closes notification popup

Scenario: Verify intrusion Timeout bar
Then HMI OP1 verifies that intrusion Timeout bar is visible on call queue item ROLE3-TWR

Scenario: OP1: Wait until Warning Period expires
When waiting for 10 seconds
Then HMI OP1 has in the call queue a number of 1 calls
Then HMI OP1 has in the collapsed area a number of 1 calls
Then HMI OP1 click on call queue Elements of active list
Then HMI OP1 has the call queue item OP2-OP1 in state connected

Scenario: Verify intrusion Timeout bar
Then HMI OP1 verifies that intrusion Timeout bar is not visible on call queue item ROLE3-TWR

Scenario: Verify OP1 call queue list
Then HMI OP1 has the call queue item ROLE3-TWR in state connected
Then HMI OP1 has in the call queue the item ROLE3-TWR with priority
Then HMI OP1 has the call queue item ROLE3-TWR in the active list with name label <<ROLE_3_NAME>>

Scenario: Verify OP1 Notification Display
!-- TODO Adjust the scenario after PVCSX-5907 is resolved
!-- When HMI OP1 opens Notification Display list
!-- Then HMI OP1 verifies that Notification Display list State has 0 items

Scenario: Verify OP2 call queue list
Then HMI OP2 has the call queue item OP1-OP2 in state connected

Scenario: Verify OP3 call queue list
Then HMI OP3 has the call queue item TWR-ROLE3 in state connected
Then HMI OP3 has in the call queue the item TWR-ROLE3 with priority

Scenario: OP1: Terminate call with OP2
When HMI OP1 presses DA key OP2(as GND)
Then HMI OP1 has in the call queue a number of 1 calls

Scenario: Verify call is terminated also for OP2
Then HMI OP2 has in the call queue a number of 0 calls

Scenario: Verify OP1 still has an active priority call with OP3
Then HMI OP1 has the call queue item ROLE3-TWR in state connected
Then HMI OP1 has in the call queue the item ROLE3-TWR with priority
Then HMI OP1 has the call queue item ROLE3-TWR in the active list with name label <<ROLE_3_NAME>>

Scenario: OP1: Terminate call with OP3
Then HMI OP1 terminates the call queue item ROLE3-TWR
Then HMI OP1 has in the call queue a number of 0 calls

Scenario: Verify call is terminated also for OP3
Then HMI OP3 has in the call queue a number of 0 calls

Scenario: Cleanup - always select first tab
When HMI OP3 with layout <<LAYOUT_MISSION3>> selects grid tab 1

Scenario: Cleanup - OP1 changes its mission back
When HMI OP1 with layout <<LAYOUT_GND>> presses function key MISSIONS
Then HMI OP1 changes current mission to mission <<MISSION_1_NAME>>
Then HMI OP1 activates mission
Then waiting for 5 seconds

Scenario: A scenario that is only executed in case of an execution failure
Meta: @RunOnFailure
GivenStories: voice_GG/ui/includes/@CleanupStory.story
Then waiting until the cleanup is done
