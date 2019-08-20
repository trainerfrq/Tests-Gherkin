 Narrative:
As an operator
I want to change mission and initiate from call history an outgoing call with a SIP address that is not part of current mission
So I can check that the call towards the corresponding entry is initiated and displays the mission's default source SIP address

Meta: @AfterStory: ../includes/@SwitchToInitialMission.story

Scenario: Booking profiles
Given booked profiles:
| profile | group | host           | identifier |
| javafx  | hmi   | <<CLIENT1_IP>> | HMI OP1    |
| javafx  | hmi   | <<CLIENT2_IP>> | HMI OP2    |
| javafx  | hmi   | <<CLIENT3_IP>> | HMI OP3    |

Scenario: Define call queue items
Given the call queue items:
| key       | source      | target      | callType |
| OP1-OP2-1 | <<MISSION1_URI>> | <<OP2_URI>> | DA/IDA   |
| OP1-OP2-2 | <<MISSION2_URI>> | <<OP2_URI>> | DA/IDA   |
| OP2-OP1   | 222222      |             | DA/IDA   |

Scenario: Caller makes a call from phonebook using dialpad
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key PHONEBOOK
When HMI OP1 writes in phonebook text box the address: 222222
When HMI OP1 initiates a call from the phonebook

Scenario: Call is initiated
Then HMI OP1 has the call queue item OP2-OP1 in state out_ringing
Then HMI OP2 has the call queue item OP1-OP2-1 in state inc_initiated
Then HMI OP2 has the call queue item OP1-OP2-1 in the waiting list with name label <<MISSION_1_NAME>>

Scenario: Caller clears outgoing call
Then HMI OP1 terminates the call queue item OP2-OP1

Scenario: Change mission for HMI OP1
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key MISSIONS
Then HMI OP1 changes current mission to mission WEST-EXEC
Then HMI OP1 activates mission
Then waiting for 5 seconds

Scenario: Caller opens call history
When HMI OP1 with layout <<LAYOUT_MISSION2>> presses function key CALLHISTORY

Scenario: Caller selects first entry from history
When HMI OP1 selects call history list entry number: 0
Then HMI OP1 verifies that call history call button has label 222222

Scenario: Caller does call from call history
		  @REQUIREMENTS:GID-2535764
		  @REQUIREMENTS:GID-4084452
When HMI OP1 initiates a call from the call history
Then HMI OP1 has the call queue item OP2-OP1 in state out_ringing
Then HMI OP2 has the call queue item OP1-OP2-2 in state inc_initiated
Then HMI OP2 has the call queue item OP1-OP2-2 in the waiting list with name label <<MISSION_2_NAME>>

Scenario: Caller clears outgoing call
Then HMI OP1 terminates the call queue item OP2-OP1

Scenario: A scenario that is only executed in case of an execution failure
Meta: @RunOnFailure
GivenStories: voice_GG/ui/includes/@CleanupUICallQueue.story,
			  voice_GG/ui/includes/@CleanupUIMission.story,
			  voice_GG/ui/includes/@CleanupUIFunctionKeys.story,
			  			  voice_GG/ui/includes/@CleanupUIWindows.story
Then waiting for 1 millisecond
