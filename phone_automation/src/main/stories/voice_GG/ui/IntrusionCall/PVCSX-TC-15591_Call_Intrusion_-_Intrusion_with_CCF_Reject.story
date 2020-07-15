Meta:
@TEST_CASE_VERSION: V1
@TEST_CASE_NAME: Call Intrusion - Intrusion with CCF Reject
@TEST_CASE_DESCRIPTION: 
GIVEN an operator that has an active DA Call and Call Intrusion set to "Enabled"
AND me as another operator having a Conditional Call Forward rule configured to forward calls to the given operator
I want to initiate an outgoing Priority call that activates the rule
So I can verify that the Priority call intrudes the active call of the given operator
@TEST_CASE_PRECONDITION: 
@TEST_CASE_PASS_FAIL_CRITERIA: 
@TEST_CASE_DEVICES_IN_USE: 
@TEST_CASE_ID: PVCSX-TC-15591
@TEST_CASE_GLOBAL_ID: GID-5601791
@TEST_CASE_API_ID: 19972694

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
| TWR-GND   | sip:507721@example.com | sip:507722@example.com |  DA/IDA   |
| GND-TWR   | sip:507722@example.com |                        |  DA/IDA   |
| ROLE2-TWR | <<ROLE2_URI>>          | sip:507721@example.com |  DA/IDA   |
| TWR-ROLE2 | sip:507721@example.com |                        |  DA/IDA   |

Scenario: OP1 changes its mission to TWR
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key MISSIONS
Then HMI OP1 changes current mission to mission <<MISSION_TWR_NAME>>
Then HMI OP1 activates mission
Then waiting for 5 seconds

Scenario: OP3 changes its mission to GND
When HMI OP3 with layout <<LAYOUT_MISSION3>> presses function key MISSIONS
Then HMI OP3 changes current mission to mission <<MISSION_GND_NAME>>
Then HMI OP3 activates mission
Then waiting for 5 seconds

Scenario: OP1: Set up an active DA call to OP3
When HMI OP1 presses DA key GND(as TWR)
Then HMI OP1 has the DA key GND(as TWR) in state out_ringing
Then HMI OP1 has the call queue item GND-TWR in state out_ringing

Scenario: OP3 receives the incoming call
Then HMI OP3 has the call queue item TWR-GND in state inc_initiated

Scenario: OP3 answers the incoming call
Then HMI OP3 accepts the call queue item TWR-GND

Scenario: Verify call is connected for both operators
Then HMI OP1 has the call queue item GND-TWR in state connected
Then HMI OP3 has the call queue item TWR-GND in state connected

Scenario: OP2 establishes a priority call to TWR
When HMI OP2 with layout <<LAYOUT_MISSION2>> selects grid tab 3
When HMI OP2 initiates a priority call on DA key TWR
Then HMI OP2 has the DA key TWR in state out_ringing

Scenario: OP1 receives the incoming priority call
Then HMI OP1 has in the call queue a number of 2 calls
Then HMI OP1 has the call queue item ROLE2-TWR in state inc_initiated

Scenario: Verify call queue section
Then HMI OP1 has in the call queue the item ROLE2-TWR with priority
Then HMI OP1 has the call queue item ROLE2-TWR in the priority list with name label <<ROLE_2_NAME>>
Then HMI OP2 has in the call queue the item TWR-ROLE2 with priority
Then HMI OP2 has the call queue item TWR-ROLE2 in the active list with name label <<MISSION_TWR_NAME>>

Scenario: OP1 rejects the incoming call
Then HMI OP1 rejects the waiting call queue item from priority list
Then HMI OP1 has in the call queue a number of 1 calls
Then HMI OP1 has the call queue item GND-TWR in state connected

Scenario: OP3 receives the rejected priority call
Then HMI OP3 has in the call queue a number of 2 calls
Then HMI OP3 has the call queue item ROLE2-TWR in state inc_ringing

Scenario: Verify call queue section
Then HMI OP2 has in the call queue the item TWR-ROLE2 with priority
Then HMI OP2 has the call queue item TWR-ROLE2 in the active list with name label <<MISSION_TWR_NAME>>
Then HMI OP3 has in the call queue the item ROLE2-TWR with priority
Then HMI OP3 has the call queue item ROLE2-TWR in the priority list with name label <<ROLE_2_NAME>>

Scenario: Verify Notification Display
When HMI OP3 opens Notification Display list
Then HMI OP3 verifies that list State contains on position 0 text Call Intrusion In Progress ...

Scenario: Close popup window
Then HMI OP3 closes notification popup

Scenario: Verify intrusion Timeout bar
Then HMI OP3 verifies that intrusion Timeout bar is visible on call queue item ROLE2-TWR

Scenario: OP3: Wait until Warning Period expires
When waiting for 10 seconds
Then HMI OP3 has in the call queue a number of 1 calls
Then HMI OP3 has in the collapsed area a number of 1 calls
Then HMI OP3 click on call queue Elements of active list
Then HMI OP3 has the call queue item TWR-GND in state connected

Scenario: Verify OP3 call queue list
Then HMI OP3 has the call queue item ROLE2-TWR in state connected
Then HMI OP3 has the call queue item ROLE2-TWR in the active list with name label <<ROLE_2_NAME>>

Scenario: Verify intrusion Timeout bar
Then HMI OP3 verifies that intrusion Timeout bar is not visible on call queue item ROLE2-TWR

Scenario: Verify OP3 Notification Display
!-- TODO Adjust the scenario after PVCSX-5907 is resolved
!-- When HMI OP3 opens Notification Display list
!-- Then HMI OP3 verifies that Notification Display list State has 0 items

Scenario: Verify OP1 call queue list
Then HMI OP1 has in the call queue a number of 1 calls
Then HMI OP1 has the call queue item GND-TWR in state connected
Then HMI OP1 has the call queue item GND-TWR in the active list with name label <<MISSION_GND_NAME>>

Scenario: Verify OP2 call queue list
Then HMI OP2 has in the call queue a number of 1 calls
Then HMI OP2 has the call queue item TWR-ROLE2 in state connected
Then HMI OP2 has the call queue item TWR-ROLE2 in the active list with name label <<MISSION_TWR_NAME>>

Scenario: OP1: Terminate call with OP3
Then HMI OP1 terminates the call queue item GND-TWR
Then HMI OP1 has in the call queue a number of 0 calls

Scenario: Verify call is terminated also for OP3
Then HMI OP3 has in the call queue a number of 1 calls
Then HMI OP3 has the call queue item ROLE2-TWR in state connected

Scenario: OP2: Terminate call with OP3
Then HMI OP2 terminates the call queue item TWR-ROLE2
Then HMI OP2 has in the call queue a number of 0 calls

Scenario: Verify call is terminated also for OP3
Then HMI OP3 has in the call queue a number of 0 calls

Scenario: Cleanup - always select first tab
When HMI OP2 with layout <<LAYOUT_MISSION2>> selects grid tab 1

Scenario: Cleanup - OP1 changes its mission back
When HMI OP1 with layout <<LAYOUT_TWR>> presses function key MISSIONS
Then HMI OP1 changes current mission to mission <<MISSION_1_NAME>>
Then HMI OP1 activates mission
Then waiting for 5 seconds

Scenario: Cleanup - OP3 changes its mission back
When HMI OP3 with layout <<LAYOUT_GND>> presses function key MISSIONS
Then HMI OP3 changes current mission to mission <<MISSION_3_NAME>>
Then HMI OP3 activates mission
Then waiting for 5 seconds

Scenario: A scenario that is only executed in case of an execution failure
Meta: @RunOnFailure
GivenStories: voice_GG/ui/includes/@CleanupStory.story
Then waiting until the cleanup is done
