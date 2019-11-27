Narrative:
As an operator
I want to change mission and initiate an outgoing DA call by clicking on a previous outgoing call's history entry
So I can check that the call towards the corresponding entry is initiated with the same attributes as the previous call

Meta: @AfterStory: ../includes/@SwitchToInitialMission.story

Scenario: Booking profiles
Given booked profiles:
| profile | group | host           | identifier |
| javafx  | hmi   | <<CLIENT1_IP>> | HMI OP1    |
| javafx  | hmi   | <<CLIENT2_IP>> | HMI OP2    |
| javafx  | hmi   | <<CLIENT3_IP>> | HMI OP3    |

Scenario: Define call queue items
Given the call queue items:
| key     | source      | target      | callType |
| OP1-OP2 | <<OP1_URI>> | <<OP2_URI>> | DA/IDA   |
| OP2-OP1 | <<OP2_URI>> | <<OP1_URI>> | DA/IDA   |

Scenario: Caller clears call history list
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key CALLHISTORY
Then HMI OP1 clears Call History list
Then HMI OP1 verifies that call history list contains 0 entries
Then HMI OP1 closes Call History popup window

Scenario: Callee clears call history list
When HMI OP2 with layout <<LAYOUT_MISSION2>> presses function key CALLHISTORY
Then HMI OP2 clears Call History list
Then HMI OP2 verifies that call history list contains 0 entries
Then HMI OP2 closes Call History popup window
Scenario: Caller establishes an outgoing call
When HMI OP1 presses DA key OP2
Then waiting for 3 seconds
Then HMI OP1 has the DA key OP2 in state out_ringing

Scenario: Callee client receives the incoming call
Then HMI OP2 has the DA key OP1 in state inc_initiated

Scenario: Callee client answers the incoming call
When HMI OP2 presses DA key OP1

Scenario: Verify call is connected for both operators
Then HMI OP1 has the call queue item OP2-OP1 in state connected
Then HMI OP1 has the DA key OP2 in state connected
Then HMI OP2 has the call queue item OP1-OP2 in state connected
Then HMI OP2 has the DA key OP1 in state connected

Scenario: Caller client clears the phone call
When HMI OP1 presses DA key OP2
And waiting for 1 second
Then HMI OP2 has in the call queue a number of 0 calls

Scenario: Change mission for HMI OP1
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key MISSIONS
Then HMI OP1 changes current mission to mission <<MISSION_2_NAME>>
Then HMI OP1 activates mission
Then waiting for 5 seconds

Scenario: Caller opens call history
When HMI OP1 with layout <<LAYOUT_MISSION2>> presses function key CALLHISTORY

Scenario: Caller selects first entry from history
When HMI OP1 selects call history list entry number: 0
Then HMI OP1 verifies that call history call button has label <<OP2_NAME>>
Then HMI OP1 verifies that call history dial button is enabled

Scenario: Caller does call from call history
		  @REQUIREMENTS:GID-2535764
		  @REQUIREMENTS:GID-4084452
When HMI OP1 initiates a call from the call history
Then HMI OP1 has the call queue item OP2-OP1 in state out_ringing
Then HMI OP2 has the call queue item OP1-OP2 in state inc_initiated
Then HMI OP2 has the call queue item OP1-OP2 in the waiting list with name label <<OP1_NAME>>

Scenario: Callee client answers the incoming call
Then HMI OP2 accepts the call queue item OP1-OP2

Scenario: Verify call is connected for both operators
Then HMI OP1 has the call queue item OP2-OP1 in state connected
Then HMI OP2 has the call queue item OP1-OP2 in state connected
Then HMI OP2 has the DA key OP1 in state connected

Scenario: Caller client clears the phone call
When HMI OP2 presses DA key OP1
Then HMI OP2 has in the call queue a number of 0 calls
Then waiting for 2 seconds
Then HMI OP1 has in the call queue a number of 0 calls

Scenario: Change mission for HMI OP2
When HMI OP2 with layout <<LAYOUT_MISSION2>> presses function key MISSIONS
Then HMI OP2 changes current mission to mission <<MISSION_1_NAME>>
Then HMI OP2 activates mission
Then waiting for 5 seconds

Scenario: Caller opens call history
When HMI OP1 with layout <<LAYOUT_MISSION2>> presses function key CALLHISTORY

Scenario: Caller selects first entry from history
When HMI OP1 selects call history list entry number: 0
Then HMI OP1 verifies that call history call button has label <<OP2_NAME>>
Then HMI OP1 verifies that call history dial button is enabled

Scenario: Caller does call from call history
		  @REQUIREMENTS:GID-2535764
		  @REQUIREMENTS:GID-4084452
		  @REQUIREMENTS:GID-4084452
When HMI OP1 initiates a call from the call history
Then HMI OP1 has the call queue item OP2-OP1 in state out_ringing
Then HMI OP2 has the call queue item OP1-OP2 in state inc_initiated
Then HMI OP2 has the call queue item OP1-OP2 in the waiting list with name label <<OP1_NAME>>
Then HMI OP1 has the call queue item OP2-OP1 in the active list with name label <<OP2_NAME>>

Scenario: Callee client answers the incoming call
Then HMI OP2 accepts the call queue item OP1-OP2

Scenario: Verify call is connected for both operators
Then HMI OP1 has the call queue item OP2-OP1 in state connected
Then HMI OP2 has the call queue item OP1-OP2 in state connected

Scenario: Clear call
Then HMI OP1 terminates the call queue item OP2-OP1
Then HMI OP2 has in the call queue a number of 0 calls
Then HMI OP1 has in the call queue a number of 0 calls

Scenario: A scenario that is only executed in case of an execution failure
Meta: @RunOnFailure
GivenStories: voice_GG/ui/includes/@CleanupUICallQueue.story,
			  voice_GG/ui/includes/@CleanupUIMission.story,
			  voice_GG/ui/includes/@CleanupUIFunctionKeys.story,
			  voice_GG/ui/includes/@CleanupUIWindows.story
Then waiting for 1 millisecond
