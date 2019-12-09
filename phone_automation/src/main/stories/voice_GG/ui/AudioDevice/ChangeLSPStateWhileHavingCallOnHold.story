Narrative:
As an operator having a call on hold
I want to change the loudspeaker state
So I can verify that the loudspeaker state is displayed correctly after call on hold is retrieved

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

Scenario: Op1 verifies Loudspeaker initial state
Then HMI OP1 with layout <<LAYOUT_MISSION1>> has the function key LOUDSPEAKER label GG LSP off

Scenario: Caller establishes an outgoing call
When HMI OP1 presses DA key OP2
Then HMI OP1 has the DA key OP2 in state out_ringing
Then HMI OP2 has the DA key OP1 in state inc_initiated
Then HMI OP2 has the call queue item OP1-OP2 in state inc_initiated

Scenario: Callee accepts incoming call
When HMI OP2 presses DA key OP1
Then HMI OP1 has the call queue item OP2-OP1 in state connected
Then HMI OP2 has the call queue item OP1-OP2 in state connected

Scenario: Caller activates loudspeaker
		  @REQUIREMENTS:GID-3005515
Then HMI OP1 with layout <<LAYOUT_MISSION1>> has the function key LOUDSPEAKER label GG LSP off
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key LOUDSPEAKER
Then HMI OP1 with layout <<LAYOUT_MISSION1>> has the function key LOUDSPEAKER label GG LSP on

Scenario: Caller puts call on hold
When HMI OP1 puts on hold the active call
Then HMI OP1 has the call queue item OP2-OP1 in state hold
Then HMI OP2 has the call queue item OP1-OP2 in state held

Scenario: Op1 verifies if Loudspeaker state is unmodified
Then HMI OP1 with layout <<LAYOUT_MISSION1>> has the function key LOUDSPEAKER label GG LSP on

Scenario: Op1 deactivates loudspeaker
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key LOUDSPEAKER
Then HMI OP1 with layout <<LAYOUT_MISSION1>> has the function key LOUDSPEAKER label GG LSP off

Scenario: Caller retrieves call from hold
Then HMI OP1 retrieves from hold the call queue item OP2-OP1
Then HMI OP1 has the call queue item OP2-OP1 in state connected
Then HMI OP2 has the call queue item OP1-OP2 in state connected

Scenario: Op1 verifies if Loudspeaker state is unmodified
Then HMI OP1 with layout <<LAYOUT_MISSION1>> has the function key LOUDSPEAKER label GG LSP off

Scenario: Callee clears outgoing call
When HMI OP2 presses DA key OP1
Then HMI OP2 has in the call queue a number of 0 calls
Then HMI OP1 has in the call queue a number of 0 calls

Scenario: A scenario that is only executed in case of an execution failure
Meta: @RunOnFailure
GivenStories: voice_GG/ui/includes/@CleanupCollapsedCallQueue.story,
			  voice_GG/ui/includes/@CleanupUICallQueueByPosition.story,
			  voice_GG/ui/includes/@CleanupUIMission.story,
			  voice_GG/ui/includes/@CleanupUIFunctionKeys.story
Then waiting for 1 millisecond


