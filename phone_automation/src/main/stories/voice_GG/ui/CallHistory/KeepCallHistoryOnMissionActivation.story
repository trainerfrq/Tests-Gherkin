Narrative:
As an operator
I want to change mission
So I can check that the call history list has the same entries

Meta: @AfterStory: ../includes/@SwitchToInitialMission.story

Scenario: Booking profiles
Given booked profiles:
| profile | group | host           | identifier |
| javafx  | hmi   | <<CLIENT1_IP>> | HMI OP1    |
| javafx  | hmi   | <<CLIENT2_IP>> | HMI OP2    |
| javafx  | hmi   | <<CLIENT3_IP>> | HMI OP3    |

Scenario: Define call history entries
Given the following call history entries:
| key    | remoteDisplayName | callDirection | callConnectionStatus |
| entry6 | <<OP1_NAME>>      | outgoing      | not_established      |
| entry5 | <<OP1_NAME>>      | outgoing      | established          |
| entry4 | <<OP1_NAME>>      | outgoing      | established          |
| entry3 | <<OP1_NAME>>      | incoming      | not_established      |
| entry2 | <<OP1_NAME>>      | incoming      | established          |
| entry1 | <<OP1_NAME>>      | outgoing      | established          |

Scenario: Caller clears call history list
When HMI OP2 with layout <<LAYOUT_MISSION2>> presses function key CALLHISTORY
Then HMI OP2 clears Call History list
Then HMI OP2 verifies that call history list contains 0 entries
Then HMI OP2 closes Call History popup window

Scenario: Caller establishes first outgoing call - not established
When HMI OP2 presses DA key OP1
Then assign date time value for entry entry6
Then HMI OP2 has the DA key OP1 in state out_ringing
Then HMI OP1 has the DA key OP2 in state inc_initiated
When HMI OP2 presses DA key OP1
Then call duration for entry entry6 is calculated

Scenario: Caller establishes second outgoing call - established
When HMI OP2 presses DA key OP1
Then assign date time value for entry entry5
Then HMI OP2 has the DA key OP1 in state out_ringing
Then HMI OP1 has the DA key OP2 in state inc_initiated
When HMI OP1 presses DA key OP2
Then HMI OP1 has the DA key OP2 in state connected
Then HMI OP2 has the DA key OP1 in state connected
And wait for 5 seconds
When HMI OP2 presses DA key OP1
Then call duration for entry entry5 is calculated

Scenario: Caller establishes third outgoing call - IA call
When HMI OP2 with layout <<LAYOUT_MISSION2>> selects grid tab 2
When HMI OP2 presses IA key IA - OP1
Then assign date time value for entry entry4
Then HMI OP2 has the IA key IA - OP1 in state connected
When HMI OP2 presses IA key IA - OP1
Then call duration for entry entry4 is calculated

Scenario: Caller establishes 4th outgoing call - incoming for OP2
When HMI OP2 with layout <<LAYOUT_MISSION2>> selects grid tab 1
When HMI OP1 presses DA key OP2
Then assign date time value for entry entry3
Then HMI OP1 has the DA key OP2 in state out_ringing
Then HMI OP2 has the DA key OP1 in state inc_initiated
Then call duration for entry entry3 is calculated
When HMI OP1 presses DA key OP2

Scenario: Caller establishes 5th outgoing IA call
When HMI OP1 with layout <<LAYOUT_MISSION1>> selects grid tab 2
When HMI OP1 presses IA key IA - OP2
Then assign date time value for entry entry2
Then HMI OP1 has the IA key IA - OP2 in state connected
And wait for 3 seconds
Then call duration for entry entry2 is calculated
When HMI OP1 presses IA key IA - OP2

Scenario: Caller establishes 6th outgoing call - priority
When HMI OP1 with layout <<LAYOUT_MISSION1>> selects grid tab 1
When HMI OP2 initiates a priority call on DA key OP1
Then assign date time value for entry entry1
Then HMI OP2 has the DA key OP1 in state out_ringing
Then HMI OP1 has the DA key OP2 in state inc_initiated
When HMI OP1 presses DA key OP2
When HMI OP1 presses DA key OP2
Then call duration for entry entry1 is calculated
Then HMI OP1 has in the call queue a number of 0 calls
Then HMI OP2 has in the call queue a number of 0 calls

Scenario: Caller opens call history
When HMI OP2 with layout <<LAYOUT_MISSION2>> presses function key CALLHISTORY

Scenario: Caller verifies the call history list
Then HMI OP2 verifies that call history list contains 6 entries
Then HMI OP2 verifies call history entry number 1 matches entry1
Then HMI OP2 verifies call history entry date format <<dateFormat>> for entry 1 matches date for entry1
Then HMI OP2 verifies call history entry time format <<timeFormat>> for entry 1 matches time for entry1
Then HMI OP2 verifies call history entry number 2 matches entry2
Then HMI OP2 verifies call history entry date format <<dateFormat>> for entry 2 matches date for entry2
Then HMI OP2 verifies call history entry time format <<timeFormat>> for entry 2 matches time for entry2
Then HMI OP2 verifies call history entry number 3 matches entry3
Then HMI OP2 verifies call history entry date format <<dateFormat>> for entry 3 matches date for entry3
Then HMI OP2 verifies call history entry time format <<timeFormat>> for entry 3 matches time for entry3
Then HMI OP2 verifies call history entry number 4 matches entry4
Then HMI OP2 verifies call history entry date format <<dateFormat>> for entry 4 matches date for entry4
Then HMI OP2 verifies call history entry time format <<timeFormat>> for entry 4 matches time for entry4
Then HMI OP2 verifies call history entry number 5 matches entry5
Then HMI OP2 verifies call history entry date format <<dateFormat>> for entry 5 matches date for entry5
Then HMI OP2 verifies call history entry time format <<timeFormat>> for entry 5 matches time for entry5
Then HMI OP2 verifies call history entry number 6 matches entry6
Then HMI OP2 verifies call history entry date format <<dateFormat>> for entry 6 matches date for entry6
Then HMI OP2 verifies call history entry time format <<timeFormat>> for entry 6 matches time for entry6

Scenario: Caller closes call history
Then HMI OP2 closes Call History popup window

Scenario: Change mission for HMI OP1
When HMI OP2 with layout <<LAYOUT_MISSION2>> presses function key MISSIONS
Then HMI OP2 changes current mission to mission <<MISSION_2_NAME>>
Then HMI OP2 activates mission
Then waiting for 5 seconds

Scenario: Caller opens call history
When HMI OP2 with layout <<LAYOUT_MISSION2>> presses function key CALLHISTORY

Scenario: Caller verifies that call history list is the same after mission change
		  @REQUIREMENTS:GID-4084003
Then HMI OP2 verifies that call history list contains 6 entries
Then HMI OP2 verifies call history entry number 1 matches entry1
Then HMI OP2 verifies call history entry date format <<dateFormat>> for entry 1 matches date for entry1
Then HMI OP2 verifies call history entry time format <<timeFormat>> for entry 1 matches time for entry1
Then HMI OP2 verifies call history entry number 2 matches entry2
Then HMI OP2 verifies call history entry date format <<dateFormat>> for entry 2 matches date for entry2
Then HMI OP2 verifies call history entry time format <<timeFormat>> for entry 2 matches time for entry2
Then HMI OP2 verifies call history entry number 3 matches entry3
Then HMI OP2 verifies call history entry date format <<dateFormat>> for entry 3 matches date for entry3
Then HMI OP2 verifies call history entry time format <<timeFormat>> for entry 3 matches time for entry3
Then HMI OP2 verifies call history entry number 4 matches entry4
Then HMI OP2 verifies call history entry date format <<dateFormat>> for entry 4 matches date for entry4
Then HMI OP2 verifies call history entry time format <<timeFormat>> for entry 4 matches time for entry4
Then HMI OP2 verifies call history entry number 5 matches entry5
Then HMI OP2 verifies call history entry date format <<dateFormat>> for entry 5 matches date for entry5
Then HMI OP2 verifies call history entry time format <<timeFormat>> for entry 5 matches time for entry5
Then HMI OP2 verifies call history entry number 6 matches entry6
Then HMI OP2 verifies call history entry date format <<dateFormat>> for entry 6 matches date for entry6
Then HMI OP2 verifies call history entry time format <<timeFormat>> for entry 6 matches time for entry6

Scenario: Caller closes call history
Then HMI OP2 closes Call History popup window

Scenario: Cleanup - always select first tab
When HMI OP1 with layout <<LAYOUT_MISSION1>> selects grid tab 1
When HMI OP2 with layout <<LAYOUT_MISSION2>> selects grid tab 1

Scenario: A scenario that is only executed in case of an execution failure
Meta: @RunOnFailure
GivenStories: voice_GG/ui/includes/@CleanupStory.story
Then waiting until the cleanup is done
