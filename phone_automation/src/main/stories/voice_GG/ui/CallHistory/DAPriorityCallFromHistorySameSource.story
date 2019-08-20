Narrative:
As an operator
I want to initiate an outgoing priority DA call by clicking on a previous outgoing priority call's history entry
So I can check that the call towards the corresponding entry is initiated with the same attributes as the previous call

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

Scenario: Caller establishes an outgoing priority call
When HMI OP1 initiates a priority call on DA key OP2
Then HMI OP1 has the DA key OP2 in state out_ringing

Scenario: Callee client receives the incoming call
Then HMI OP2 has the DA key OP1 in state inc_initiated
Then HMI OP2 has in the call queue the item OP1-OP2 with priority

Scenario: Callee client answers the incoming call
When HMI OP2 presses DA key OP1

Scenario: Verify call is connected for both operators
Then HMI OP1 has the call queue item OP2-OP1 in state connected
Then HMI OP2 has the call queue item OP1-OP2 in state connected

Scenario: Caller client clears the phone call
When HMI OP1 presses DA key OP2
Then HMI OP2 has in the call queue a number of 0 calls

Scenario: Caller opens call history
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key CALLHISTORY

Scenario: Caller selects first entry from history
When HMI OP1 selects call history list entry number: 0

Scenario: Caller does call from call history
		  @REQUIREMENTS:GID-2535764
		  @REQUIREMENTS:GID-2536682
When HMI OP1 initiates a call from the call history
Then HMI OP1 has the DA key OP2 in state out_ringing

Scenario: Callee client receives the incoming call
Then HMI OP2 has the DA key OP1 in state inc_initiated
Then HMI OP2 has in the call queue the item OP1-OP2 with priority

Scenario: Callee client answers the incoming call
When HMI OP2 presses DA key OP1

Scenario: Verify call is connected for both operators
		  @REQUIREMENTS:GID-2535771
Then HMI OP1 has the call queue item OP2-OP1 in state connected
Then HMI OP2 has the call queue item OP1-OP2 in state connected

Scenario: Caller client clears the phone call
When HMI OP1 presses DA key OP2
Then HMI OP2 has in the call queue a number of 0 calls

Scenario: Call is terminated also for caller
Then HMI OP1 has in the call queue a number of 0 calls

Scenario: A scenario that is only executed in case of an execution failure
Meta: @RunOnFailure
GivenStories: voice_GG/ui/includes/@CleanupUICallQueue.story,
			  voice_GG/ui/includes/@CleanupUIMission.story,
			  voice_GG/ui/includes/@CleanupUIFunctionKeys.story,
			  voice_GG/ui/includes/@CleanupUIWindows.story
Then waiting for 1 millisecond
