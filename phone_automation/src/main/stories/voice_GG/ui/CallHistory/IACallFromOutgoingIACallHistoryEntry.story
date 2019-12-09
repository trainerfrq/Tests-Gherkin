Narrative:
As an operator
I want to initiate an outgoing IA call by clicking on a previous outgoing IA call's history entry
So I can check that the call towards the corresponding entry is initiated as an outgoing IA call using the destination according to the selected call

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

Scenario: OP1 establishes an outgoing IA call
When HMI OP1 with layout <<LAYOUT_MISSION1>> selects grid tab 2
When HMI OP1 presses IA key IA - OP2
Then HMI OP1 has the call queue item OP2-OP1 in state connected
Then HMI OP1 has the IA key IA - OP2 in state connected

Scenario: OP2 receives incoming IA call
When HMI OP2 with layout <<LAYOUT_MISSION2>> selects grid tab 2
Then HMI OP2 has the call queue item OP1-OP2 in state connected
Then HMI OP2 has the IA key IA - OP1 in state connected

Scenario: Cleanup IA call
When HMI OP1 presses IA key IA - OP2
Then HMI OP1 has in the call queue a number of 0 calls

Scenario: Call is terminated also for callee
Then HMI OP2 has in the call queue a number of 0 calls

Scenario: OP1 opens call history
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key CALLHISTORY

Scenario: OP1 selects first entry from history
When HMI OP1 selects call history list entry number: 0

Scenario: Caller does call from call history
		  @REQUIREMENTS:GID-2535764
		  @REQUIREMENTS:GID-2505706
!-- TODO Disable story until bug QXVP-14263 is fixed
When HMI OP1 initiates a call from the call history
Then HMI OP1 has the call queue item OP2-OP1 in state connected
Then HMI OP1 has the IA key IA - OP2 in state connected

Scenario: OP2 receives incoming IA call
Then HMI OP2 has the call queue item OP1-OP2 in state connected
Then HMI OP2 has the IA key IA - OP1 in state connected

Scenario: Cleanup IA call
When HMI OP1 presses IA key IA - OP2
Then HMI OP1 has in the call queue a number of 0 calls

Scenario: Call is terminated also for callee
Then HMI OP2 has in the call queue a number of 0 calls

Scenario: Cleanup - always select first tab
When HMI OP1 with layout <<LAYOUT_MISSION1>> selects grid tab 1
When HMI OP2 with layout <<LAYOUT_MISSION2>> selects grid tab 1

Scenario: A scenario that is only executed in case of an execution failure
Meta: @RunOnFailure
GivenStories: voice_GG/ui/includes/@CleanupCollapsedCallQueue.story,
			  voice_GG/ui/includes/@CleanupUICallQueueByPosition.story,
			  voice_GG/ui/includes/@CleanupUIMission.story,
			  voice_GG/ui/includes/@CleanupUIFunctionKeys.story
Then waiting for 1 millisecond
