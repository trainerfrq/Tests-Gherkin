Narrative:
As a caller operator having an active calls
I want to activate Call Forward
So I can verify that the existing calls are not affected by Call Forward functionality

Scenario: Booking profiles
Given booked profiles:
| profile | group | host           | identifier |
| javafx  | hmi   | <<CLIENT1_IP>> | HMI OP1    |
| javafx  | hmi   | <<CLIENT2_IP>> | HMI OP2    |
| javafx  | hmi   | <<CLIENT3_IP>> | HMI OP3    |

Scenario: Define call queue items
Given the call queue items:
| key     | source      | target      | callType |
| OP1-OP2 | <<OP1_URI>> | <<OP2_URI>> | IA       |
| OP2-OP1 | <<OP2_URI>> | <<OP1_URI>> | IA       |
| OP1-OP3 | <<OP1_URI>> | <<OP3_URI>> | DA/IDA   |
| OP3-OP1 | <<OP3_URI>> | <<OP1_URI>> | DA/IDA   |

Scenario: Op1 establishes an outgoing call
When HMI OP1 presses DA key OP3
Then HMI OP1 has the DA key OP3 in state out_ringing

Scenario: Op3 receives the incoming call
Then HMI OP3 has the DA key OP1 in state inc_initiated

Scenario: Op3 client answers the incoming call
When HMI OP3 presses DA key OP1

Scenario: Verify call is connected for both operators
Then HMI OP1 has the call queue item OP3-OP1 in state connected
Then HMI OP3 has the call queue item OP1-OP3 in state connected

Scenario: Op1 puts call on hold
When HMI OP1 puts on hold the active call
Then HMI OP1 has the call queue item OP3-OP1 in state hold
Then HMI OP3 has the call queue item OP1-OP3 in state held

Scenario: Op1 establishes an outgoing IA call
When HMI OP1 with layout <<LAYOUT_MISSION1>> selects grid tab 2
When HMI OP1 presses IA key IA - OP2
Then HMI OP1 has the call queue item OP2-OP1 in state connected
Then HMI OP1 has the IA key IA - OP2 in state connected

Scenario: Op1 receives incoming IA call
When HMI OP2 with layout <<LAYOUT_MISSION2>> selects grid tab 2
Then HMI OP2 has the call queue item OP1-OP2 in state connected
Then HMI OP2 has the IA key IA - OP1 in state connected

Scenario: Verify call direction
Then HMI OP1 has the IA call queue item OP2-OP1 with audio direction tx
Then HMI OP2 has the IA call queue item OP1-OP2 with audio direction rx

Scenario: Op1 activates Call Forward
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key CALLFORWARD
Then HMI OP1 with layout <<LAYOUT_MISSION1>> has the function key CALLFORWARD in forwardOngoing state

Scenario: Op1 chooses Op2 as call forward target
		  @REQUIREMENTS:GID-2521111
When HMI OP1 with layout <<LAYOUT_MISSION1>> selects grid tab 1
When HMI OP1 presses DA key OP2
Then HMI OP1 with layout <<LAYOUT_MISSION1>> has the function key CALLFORWARD in active state
Then HMI OP1 verifies that call queue info container is visible

Scenario: Verify calls state on all operators
Then HMI OP1 has in the call queue a number of 2 calls
Then HMI OP2 has in the call queue a number of 1 calls
Then HMI OP3 has in the call queue a number of 1 calls

Scenario: Op2 establishes an outgoing IA call
When HMI OP2 presses IA key IA - OP1

Scenario: Verify call direction
Then HMI OP1 has the IA call queue item OP2-OP1 with audio direction duplex
Then HMI OP2 has the IA call queue item OP1-OP2 with audio direction duplex

Scenario: Verify calls state on all operators
Then HMI OP1 has in the call queue a number of 2 calls
Then HMI OP2 has in the call queue a number of 1 calls
Then HMI OP3 has in the call queue a number of 1 calls

Scenario: Op1 client clears the IA phone call
When HMI OP1 with layout <<LAYOUT_MISSION1>> selects grid tab 2
When HMI OP1 presses DA key IA - OP2

Scenario: Cleanup IA call
When HMI OP2 presses IA key IA - OP1
Then HMI OP2 has in the call queue a number of 0 calls

Scenario: Op1 still has Call Forward active
Then HMI OP1 with layout <<LAYOUT_MISSION1>> has the function key CALLFORWARD in active state
Then HMI OP1 verifies that call queue info container is visible

Scenario: Op1 retrieves call from hold
Then HMI OP1 retrieves from hold the call queue item OP3-OP1
Then HMI OP1 has in the call queue a number of 1 calls
Then HMI OP3 has in the call queue a number of 1 calls

Scenario: Op1 still has Call Forward active
Then HMI OP1 with layout <<LAYOUT_MISSION1>> has the function key CALLFORWARD in active state

Scenario: Op1 client clears the phone call
When HMI OP1 with layout <<LAYOUT_MISSION1>> selects grid tab 1
When HMI OP1 presses DA key OP3
Then HMI OP1 has in the call queue a number of 0 calls
Then HMI OP3 has in the call queue a number of 0 calls

Scenario: Op1 deactivates Call Forward
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key CALLFORWARD
Then HMI OP1 verifies that call queue info container is not visible

Scenario: Cleanup - always select first tab
When HMI OP1 with layout <<LAYOUT_MISSION1>> selects grid tab 1
When HMI OP2 with layout <<LAYOUT_MISSION2>> selects grid tab 1

Scenario: A scenario that is only executed in case of an execution failure
Meta: @RunOnFailure
GivenStories: voice_GG/ui/includes/@CleanupCollapsedCallQueue.story,			  voice_GG/ui/includes/@CleanupUICallQueueByPosition.story,
			  voice_GG/ui/includes/@CleanupUIMission.story,
			  voice_GG/ui/includes/@CleanupUIFunctionKeys.story
Then waiting for 1 millisecond
