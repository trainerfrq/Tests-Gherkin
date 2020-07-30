Meta:
@TEST_CASE_VERSION: V1
@TEST_CASE_NAME: Call Intrusion - Priority Call on Role target
@TEST_CASE_DESCRIPTION: 
As an operator
I want to initiate an outgoing Priority call towards a role
So I can verify that the Priority call intrudes the active call of one of the logged in operators
(which are part of the target role) and declined by all the other operators
@TEST_CASE_PRECONDITION: 
@TEST_CASE_PASS_FAIL_CRITERIA: 
@TEST_CASE_DEVICES_IN_USE: 
@TEST_CASE_ID: PVCSX-TC-15587
@TEST_CASE_GLOBAL_ID: GID-5600741
@TEST_CASE_API_ID: 19969651

Scenario: Booking profiles
Given booked profiles:
| profile | group | host           | identifier |
| javafx  | hmi   | <<CLIENT1_IP>> | HMI OP1    |
| javafx  | hmi   | <<CLIENT2_IP>> | HMI OP2    |
| javafx  | hmi   | <<CLIENT3_IP>> | HMI OP3    |

Scenario: Define call queue items
Given the call queue items:
| key       | source                 | target                 | callType |
| OP1-OP2   | <<OP1_URI>>            | <<OP2_URI>>            | DA/IDA   |
| OP2-OP1   | <<OP2_URI>>            | <<OP1_URI>>            | DA/IDA   |
| OP1-OP3   | <<OP1_URI>>            | <<OP3_URI>>            | DA/IDA   |
| OP3-OP1   | <<OP3_URI>>            | <<OP1_URI>>            | DA/IDA   |
| ALL-ROLE3 | sip:507799@example.com |                        | DA/IDA   |
| ROLE3-ALL | <<ROLE3_URI>>          | sip:507799@example.com | DA/IDA   |

Scenario: OP1 changes its mission to APP
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key MISSIONS
Then HMI OP1 changes current mission to mission <<MISSION_GND_NAME>>
Then HMI OP1 activates mission
Then waiting for 5 seconds

Scenario: OP2 changes its mission to GND
When HMI OP2 with layout <<LAYOUT_MISSION2>> presses function key MISSIONS
Then HMI OP2 changes current mission to mission <<MISSION_APP_NAME>>
Then HMI OP2 activates mission
Then waiting for 5 seconds

Scenario: OP1: Set up an active DA call to OP2
When HMI OP1 presses DA key OP2(as GND)
Then HMI OP1 has the DA key OP2(as GND) in state out_ringing
Then HMI OP1 has the call queue item OP2-OP1 in state out_ringing

Scenario: OP2 receives the incoming call
Then HMI OP2 has the call queue item OP1-OP2 in state inc_initiated

Scenario: OP2 answers the incoming call
Then HMI OP2 accepts the call queue item OP1-OP2

Scenario: Verify call is connected for both operators
Then HMI OP1 has the call queue item OP2-OP1 in state connected
Then HMI OP2 has the call queue item OP1-OP2 in state connected

Scenario: OP3 initiates a priority call from phone book
When HMI OP3 with layout <<LAYOUT_MISSION3>> presses function key PHONEBOOK
When HMI OP3 selects call route selector: none
When HMI OP3 writes in phonebook text box: ALL
And waiting for 1 second
When HMI OP3 selects phonebook entry number: 0
Then HMI OP3 verifies that phone book text box displays text ALL
When HMI OP3 toggles call priority
Then HMI OP3 verifies that phone book priority toggle is active
When HMI OP3 initiates a call from the phonebook

Scenario: Verify OP3 call queue section
Then HMI OP3 has the call queue item ALL-ROLE3 in state out_ringing
Then HMI OP3 has the call queue item ALL-ROLE3 in the active list with name label ALL

Scenario: OP1 receives the incoming priority call
Then HMI OP1 has in the call queue a number of 2 calls
Then HMI OP1 has the call queue item ROLE3-ALL in state inc_ringing
Then HMI OP1 has in the call queue the item ROLE3-ALL with priority
Then HMI OP1 has the call queue item ROLE3-ALL in the priority list with name label <<ROLE_3_NAME>>

Scenario: OP2 receives the incoming priority call
Then HMI OP2 has in the call queue a number of 2 calls
Then HMI OP2 has the call queue item ROLE3-ALL in state inc_ringing
Then HMI OP2 has in the call queue the item ROLE3-ALL with priority
Then HMI OP2 has the call queue item ROLE3-ALL in the priority list with name label <<ROLE_3_NAME>>

Scenario: OP1 verify Notification Display
When HMI OP1 opens Notification Display list
Then HMI OP1 verifies that list State contains on position 0 text Call Intrusion In Progress ...

Scenario: Close popup window
Then HMI OP1 closes notification popup

Scenario: OP2 verify Notification Display
When HMI OP2 opens Notification Display list
Then HMI OP2 verifies that list State contains on position 0 text Call Intrusion In Progress ...

Scenario: Close popup window
Then HMI OP2 closes notification popup

Scenario: OP1 verify intrusion Timeout bar
Then HMI OP1 verifies that intrusion Timeout bar is visible on call queue item ROLE3-ALL

Scenario: OP2 verify intrusion Timeout bar
Then HMI OP2 verifies that intrusion Timeout bar is visible on call queue item ROLE3-ALL

Scenario: OP1: Wait until Warning Period expires
When waiting for 10 seconds

Scenario: Intrusion call takes place for one operator and declined for the others
Then the call queue item ROLE3-ALL is connected for only one of the operator positions: HMI OP1, HMI OP2

Scenario: OP3: Terminate priority call
Then HMI OP3 terminates the call queue item ALL-ROLE3
Then HMI OP3 has in the call queue a number of 0 calls

Scenario: Verify DA call is still connected for both operators
Then HMI OP1 has the call queue item OP2-OP1 in state connected
Then HMI OP2 has the call queue item OP1-OP2 in state connected

Scenario: OP1: Terminate call with OP2
Then HMI OP1 terminates the call queue item OP2-OP1
Then HMI OP1 has in the call queue a number of 0 calls
Then HMI OP2 has in the call queue a number of 0 calls

Scenario: Cleanup - OP1 changes its mission back
When HMI OP1 with layout <<LAYOUT_GND>> presses function key MISSIONS
Then HMI OP1 changes current mission to mission <<MISSION_1_NAME>>
Then HMI OP1 activates mission
Then waiting for 5 seconds

Scenario: Cleanup - OP2 changes its mission back
When HMI OP2 with layout <<LAYOUT_APP>> presses function key MISSIONS
Then HMI OP2 changes current mission to mission <<MISSION_2_NAME>>
Then HMI OP2 activates mission
Then waiting for 5 seconds

Scenario: A scenario that is only executed in case of an execution failure
Meta: @RunOnFailure
GivenStories: voice_GG/ui/includes/@CleanupStory.story
Then waiting until the cleanup is done
