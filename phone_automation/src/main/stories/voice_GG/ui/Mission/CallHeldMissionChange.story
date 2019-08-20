Narrative:
As a caller operator having a held call on my side
I want to do change mission actions
So I can verify that calls are not affected by these actions

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
| OP3-OP2 | <<OP3_URI>> | <<OP2_URI>> | DA/IDA   |
| OP2-OP3 | <<OP2_URI>> | <<OP3_URI>> | DA/IDA   |

Scenario: Op1 establishes an outgoing call
When HMI OP1 presses DA key OP2
Then HMI OP1 has the DA key OP2 in state out_ringing

Scenario: Op2 client receives the incoming call
Then HMI OP2 has the DA key OP1 in state inc_initiated
Then HMI OP2 has the call queue item OP1-OP2 in state inc_initiated

Scenario: Callee client answers the incoming call
Then HMI OP2 accepts the call queue item OP1-OP2

Scenario: Verify call is connected for both operators
Then HMI OP1 has the call queue item OP2-OP1 in state connected
Then HMI OP2 has the call queue item OP1-OP2 in state connected

Scenario: Callee puts call on hold
When HMI OP2 puts on hold the active call
Then HMI OP2 has the call queue item OP1-OP2 in state hold
Then HMI OP1 has the call queue item OP2-OP1 in state held

Scenario: Change mission for HMI OP1
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key MISSIONS
Then HMI OP1 changes current mission to mission WEST-EXEC
Then HMI OP1 activates mission
Then waiting for 5 seconds

Scenario: Verify call state
		   @REQUIREMENTS: GID-3005111
Then HMI OP2 has the call queue item OP1-OP2 in state hold
Then HMI OP1 has the call queue item OP2-OP1 in state held

Scenario: Op3 establishes an outgoing call
When HMI OP3 presses DA key OP2
Then HMI OP3 has the DA key OP2 in state out_ringing

Scenario: Op2 client receives the incoming call
Then HMI OP2 has the DA key OP3 in state inc_initiated
Then HMI OP2 has the call queue item OP3-OP2 in state inc_initiated

Scenario: Callee client answers the incoming call
Then HMI OP2 accepts the call queue item OP3-OP2

Scenario: Verify call is connected for both operators
Then HMI OP3 has the call queue item OP2-OP3 in state connected
Then HMI OP2 has the call queue item OP3-OP2 in state connected

Scenario: Change mission for HMI OP2
When HMI OP2 with layout <<LAYOUT_MISSION2>> presses function key MISSIONS
Then HMI OP2 changes current mission to mission MAN-NIGHT-TACT
Then HMI OP2 activates mission
Then waiting for 5 seconds

Scenario: Verify call state
		   @REQUIREMENTS: GID-3005111
Then HMI OP1 has the call queue item OP2-OP1 in state held
Then HMI OP2 has the call queue item OP1-OP2 in state hold
Then HMI OP2 has the call queue item OP3-OP2 in state connected

Scenario: Callee puts call on hold
When HMI OP2 puts on hold the active call
Then HMI OP2 has the call queue item OP3-OP2 in state hold
Then HMI OP3 has the call queue item OP2-OP3 in state held

Scenario: Change mission for HMI OP3
When HMI OP3 with layout <<LAYOUT_MISSION3>> presses function key MISSIONS
Then HMI OP3 changes current mission to mission WEST-EXEC
Then HMI OP3 activates mission
Then waiting for 5 seconds

Scenario: Verify call state
		   @REQUIREMENTS: GID-3005111
Then HMI OP2 has the call queue item OP3-OP2 in state hold
Then HMI OP3 has the call queue item OP2-OP3 in state held

Scenario: Caller retrieves call from held
Then HMI OP2 retrieves from hold the call queue item OP3-OP2

Scenario: Op3 change mission
When HMI OP3 with layout <<LAYOUT_MISSION2>> presses function key MISSIONS
Then HMI OP3 changes current mission to mission EAST-EXEC
Then HMI OP3 activates mission
Then waiting for 5 seconds

Scenario: Verify operator mission
Then HMI OP3 has in the DISPLAY STATUS section mission the assigned mission EAST-EXEC

Scenario: Verify call is connected for both operators
Then HMI OP3 has the call queue item OP2-OP3 in state connected
Then HMI OP2 has the call queue item OP3-OP2 in state connected

Scenario: Caller clears outgoing call
When HMI OP3 presses DA key OP2

Scenario: Callee retrieves call from hold
Then HMI OP2 retrieves from hold the call queue item OP1-OP2

Scenario: Verify call is connected for both operators
Then HMI OP1 has the call queue item OP2-OP1 in state connected
Then HMI OP2 has the call queue item OP1-OP2 in state connected

Scenario: Caller clears outgoing call
Then HMI OP1 terminates the call queue item OP2-OP1

Scenario: Verify all cals were cleared
Then HMI OP1 has in the call queue a number of 0 calls
Then HMI OP2 has in the call queue a number of 0 calls
Then HMI OP3 has in the call queue a number of 0 calls

Scenario: A scenario that is only executed in case of an execution failure
Meta: @RunOnFailure
GivenStories: voice_GG/ui/includes/@CleanupUICallQueue.story,
			  voice_GG/ui/includes/@CleanupUIMission.story,
			  voice_GG/ui/includes/@CleanupUIFunctionKeys.story,
			  voice_GG/ui/includes/@CleanupUIWindows.story
Then waiting for 1 millisecond




