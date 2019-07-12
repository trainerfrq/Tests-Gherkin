Narrative:
As an operator
I want to initiate an outgoing DA call by clicking on a previous incoming IA call's history entry
So I can check that the call towards the corresponding entry is initiated as a routine call using the destination according to the selected call

Scenario: Booking profiles
Given booked profiles:
| profile | group | host           | identifier |
| javafx  | hmi   | <<CLIENT1_IP>> | HMI OP1    |
| javafx  | hmi   | <<CLIENT2_IP>> | HMI OP2    |

Scenario: Define call queue items
Given the call queue items:
| key        | source      | target      | callType |
| OP1-OP2-IA | <<OP1_URI>> | <<OP2_URI>> | IA       |
| OP2-OP1-IA | <<OP2_URI>> | <<OP1_URI>> | IA       |
| OP1-OP2-DA | <<OP1_URI>> | <<OP2_URI>> | DA/IDA   |
| OP2-OP1-DA | <<OP2_URI>> | <<OP1_URI>> | DA/IDA   |

Scenario: OP1 establishes an outgoing IA call
When HMI OP1 with layout <<LAYOUT_MISSION1>> selects grid tab 2
When HMI OP1 presses IA key IA - OP2
Then HMI OP1 has the call queue item OP2-OP1-IA in state connected
Then HMI OP1 has the IA key IA - OP2 in state connected

Scenario: OP2 receives incoming IA call
When HMI OP2 with layout <<LAYOUT_MISSION2>> selects grid tab 2
Then HMI OP2 has the call queue item OP1-OP2-IA in state connected
Then HMI OP2 has the IA key IA - OP1 in state connected

Scenario: Cleanup IA call
When HMI OP1 presses IA key IA - OP2
Then HMI OP1 has in the call queue a number of 0 calls

Scenario: Call is terminated also for callee
Then HMI OP2 has in the call queue a number of 0 calls

Scenario: OP2 opens call history
When HMI OP2 with layout <<LAYOUT_MISSION2>> presses function key CALLHISTORY

Scenario: OP2 selects first entry from history
When HMI OP2 selects call history list entry number: 0

Scenario: OP2 does call from call history
		  @REQUIREMENTS:GID-2535764
		  @REQUIREMENTS:GID-2536683
		  @REQUIREMENTS:GID-2656702
When HMI OP2 initiates a call from the call history
When HMI OP2 with layout <<LAYOUT_MISSION2>> selects grid tab 1

Then HMI OP2 has the DA key OP1 in state out_ringing

Scenario: OP1 client receives the incoming call
When HMI OP1 with layout <<LAYOUT_MISSION1>> selects grid tab 1
Then HMI OP1 has the DA key OP2 in state inc_initiated

Scenario: OP1 client answers the incoming call
When HMI OP1 presses DA key OP2

Scenario: Verify call is connected for both operators
Then HMI OP1 has the call queue item OP2-OP1-DA in state connected
Then HMI OP2 has the call queue item OP1-OP2-DA in state connected

Scenario: Caller client clears the phone call
When HMI OP1 presses DA key OP2
Then HMI OP2 has in the call queue a number of 0 calls

Scenario: Call is terminated also for caller
Then HMI OP1 has in the call queue a number of 0 calls

Scenario: Cleanup - always select first tab
When HMI OP1 with layout <<LAYOUT_MISSION1>> selects grid tab 1
When HMI OP2 with layout <<LAYOUT_MISSION2>> selects grid tab 1
