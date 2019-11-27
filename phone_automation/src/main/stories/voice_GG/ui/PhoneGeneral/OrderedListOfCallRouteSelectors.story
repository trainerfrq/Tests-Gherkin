Narrative:
As an operator
I want to add up to 10 Call Route Selectors
So I can verify that the Call Route Selector are order in the same manner as they were configured

Scenario: Booking profiles
Given booked profiles:
| profile | group | host           | identifier |
| javafx  | hmi   | <<CLIENT1_IP>> | HMI OP1    |
| javafx  | hmi   | <<CLIENT2_IP>> | HMI OP2    |
| javafx  | hmi   | <<CLIENT3_IP>> | HMI OP3    |

Scenario: Verify Call Route Selector List for mission MISSION_1_NAME
		  @REQUIREMENTS:GID-2877918
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key PHONEBOOK
Then HMI OP1 verifies the Call Route Selector list for mission <<MISSION_1_NAME>> from /configuration-files/<<systemName>>/missions.json

Scenario: Op1 closes phone book
When HMI OP1 closes phonebook

Scenario: Verify Call Route Selector List for mission MISSION_2_NAME
When HMI OP2 with layout <<LAYOUT_MISSION2>> presses function key PHONEBOOK
Then HMI OP2 verifies the Call Route Selector list for mission <<MISSION_2_NAME>> from /configuration-files/<<systemName>>/missions.json

Scenario: Op2 closes phone book
When HMI OP2 closes phonebook

Scenario: Verify Call Route Selector List for mission <ISSION_3_NAME
When HMI OP3 with layout <<LAYOUT_MISSION3>> presses function key PHONEBOOK
Then HMI OP3 verifies the Call Route Selector list for mission <<MISSION_3_NAME>> from /configuration-files/<<systemName>>/missions.json

Scenario: Op3 closes phone book
When HMI OP3 closes phonebook

Scenario: A scenario that is only executed in case of an execution failure
Meta: @RunOnFailure
GivenStories: voice_GG/ui/includes/@CleanupUICallQueue.story,
			  voice_GG/ui/includes/@CleanupUIMission.story,
			  voice_GG/ui/includes/@CleanupUIFunctionKeys.story,
			  voice_GG/ui/includes/@CleanupUIWindows.story
Then waiting for 1 millisecond
