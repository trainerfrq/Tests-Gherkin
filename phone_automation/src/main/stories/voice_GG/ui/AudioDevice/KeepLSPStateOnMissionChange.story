Narrative:
As an operator
I want to change mission
So I can verify that the state of the Loudspeaker doesn't change

Scenario: Booking profiles
Given booked profiles:
| profile | group | host           | identifier |
| javafx  | hmi   | <<CLIENT1_IP>> | HMI OP1    |
| javafx  | hmi   | <<CLIENT2_IP>> | HMI OP2    |

Scenario: Define call queue items
Given the call queue items:
| key     | source      | target      | callType |
| OP1-OP2 | <<OP1_URI>> | <<OP2_URI>> | DA/IDA   |
| OP2-OP1 | <<OP2_URI>> | <<OP1_URI>> | DA/IDA   |

Scenario: Op1 verifies Loudspeaker state
Then HMI OP1 with layout <<LAYOUT_MISSION1>> has the function key LOUDSPEAKER label GG LSP off

Scenario: Caller establishes an outgoing call
When HMI OP1 presses DA key OP2
Then waiting for 3 seconds
Then HMI OP1 has the DA key OP2 in state out_ringing

Scenario: Callee client receives the incoming call
Then HMI OP2 has the DA key OP1 in state inc_initiated

Scenario: Callee client answers the incoming call
Then HMI OP2 accepts the call queue item OP1-OP2
Then HMI OP1 has the call queue item OP2-OP1 in state connected
Then HMI OP2 has the call queue item OP1-OP2 in state connected

Scenario: Op1 activates loudspeaker
		  @REQUIREMENTS:GID-3005515
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key LOUDSPEAKER
Then HMI OP1 with layout <<LAYOUT_MISSION1>> has the function key LOUDSPEAKER label GG LSP on

Scenario: Op1 changes mission
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key MISSIONS
Then HMI OP1 changes current mission to mission <<MISSION_2_NAME>>
Then HMI OP1 activates mission
Then waiting for 5 seconds

Scenario: Op1 verifies if Loudspeaker state is unmodified
Then HMI OP1 with layout <<LAYOUT_MISSION2>> has the function key LOUDSPEAKER label GG LSP on

Scenario: Verify active call is still connected
Then HMI OP1 has the call queue item OP2-OP1 in state connected
Then HMI OP2 has the call queue item OP1-OP2 in state connected

Scenario: Op1 deactivates loudspeaker
When HMI OP1 with layout <<LAYOUT_MISSION2>> presses function key LOUDSPEAKER
Then HMI OP1 with layout <<LAYOUT_MISSION2>> has the function key LOUDSPEAKER label GG LSP off

Scenario: Op1 changes to initial mission
When HMI OP1 with layout <<LAYOUT_MISSION2>> presses function key MISSIONS
Then HMI OP1 changes current mission to mission <<MISSION_1_NAME>>
Then HMI OP1 activates mission
Then waiting for 5 seconds

Scenario: Clear call
Then HMI OP1 terminates the call queue item OP2-OP1
Then HMI OP2 has in the call queue a number of 0 calls
Then HMI OP1 has in the call queue a number of 0 calls

Scenario: Op1 verifies if Loudspeaker state is unmodified
Then HMI OP1 with layout <<LAYOUT_MISSION1>> has the function key LOUDSPEAKER label GG LSP off

Scenario: A scenario that is only executed in case of an execution failure
Meta: @RunOnFailure
GivenStories: voice_GG/ui/includes/@CleanupCollapsedCallQueue.story,
			  voice_GG/ui/includes/@CleanupUICallQueueByPosition.story,
			  voice_GG/ui/includes/@CleanupUIMission.story,
			  voice_GG/ui/includes/@CleanupUIFunctionKeys.story
Then waiting for 1 millisecond
