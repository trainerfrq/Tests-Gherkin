Narrative:
As an operator
I want to establish a call using a DA key
So I can verify the displayed Call State and Type and the allowed operations for the DA key.

Scenario: Booking profiles
Given booked profiles:
| profile | group | host           | identifier |
| javafx  | hmi   | <<CLIENT1_IP>> | HMI OP1    |
| javafx  | hmi   | <<CLIENT2_IP>> | HMI OP2    |

Scenario: Caller establishes an outgoing call
 		  @REQUIREMENTS:GID-3229741
		  @REQUIREMENTS:GID-3229742
		  @REQUIREMENTS:GID-3229743
When HMI OP1 presses DA key OP2
Then HMI OP1 has the DA key OP2 in state out_ringing
Then HMI OP1 verifies that the DA key OP2 has the type label DA

Scenario: Callee client receives and answers the incoming call
		  @REQUIREMENTS:GID-4086404
Then HMI OP2 has the DA key OP1 in state inc_initiated
Then HMI OP2 verifies that the DA key OP1 has the type label DA
When HMI OP2 presses DA key OP1

Scenario: Verify call is connected for both operators
Then HMI OP1 has the DA key OP2 in state connected
Then HMI OP1 verifies that the DA key OP2 has the type label DA
Then HMI OP2 has the DA key OP1 in state connected
Then HMI OP2 verifies that the DA key OP1 has the type label DA

Scenario: Operator puts active call on hold, using a DA key
When HMI OP2 puts on hold the active call using DA key OP1

Scenario: Verify call is on hold
Then HMI OP1 has the DA key OP2 in state held
Then HMI OP2 has the DA key OP1 in state hold

Scenario: Operator retrieves call from hold
When HMI OP2 presses DA key OP1

Scenario: Verify call is connected for both operators
Then HMI OP1 has the DA key OP2 in state connected
Then HMI OP1 verifies that the DA key OP2 has the type label DA
Then HMI OP2 has the DA key OP1 in state connected
Then HMI OP2 verifies that the DA key OP1 has the type label DA

Scenario: Operator initiates transfer
When HMI OP2 initiates a transfer using the DA key OP1

Scenario: Verify call is put on hold
Then HMI OP2 has the DA key OP1 in state hold
Then HMI OP1 has the DA key OP2 in state held

Scenario: Operator retrieves call from hold
When HMI OP2 presses DA key OP1

Scenario: Caller client clears the phone call
When HMI OP1 presses DA key OP2

Scenario: Call is terminated for both operators
Then HMI OP1 has the DA key OP2 in state terminated
Then HMI OP1 verifies that the DA key OP2 has the type label DA
Then HMI OP2 has the DA key OP1 in state terminated
Then HMI OP2 verifies that the DA key OP1 has the type label DA

Scenario: Caller establishes a priority call, using a DA key
When HMI OP1 initiates a priority call on DA key OP2
Then HMI OP1 has the DA key OP2 in state out_ringing
Then HMI OP1 verifies that the DA key OP2 has the type label DA

Scenario: Callee client receives and rejects the incoming call
		  @REQUIREMENTS:GID-4086404
Then HMI OP2 has the DA key OP1 in state inc_initiated
When HMI OP2 declines the call on DA key OP1
Then HMI OP1 has the DA key OP2 in state out_failed

Scenario: Caller establishes an outgoing IA call, using a key
When HMI OP1 with layout <<LAYOUT_MISSION1>> selects grid tab 2
When HMI OP2 with layout <<LAYOUT_MISSION2>> selects grid tab 2
When HMI OP1 presses IA key IA - OP2
Then HMI OP1 has the IA key IA - OP2 in state connected
Then HMI OP2 has the IA key IA - OP1 in state connected

Scenario: Cleanup IA call
When HMI OP1 presses IA key IA - OP2
Then waiting for 1 seconds
Then HMI OP1 has in the call queue a number of 0 calls
Then HMI OP2 has in the call queue a number of 0 calls

Scenario: Wait a few seconds for clean-up purposes
Then waiting for 10 seconds

Scenario: Cleanup - always select first tab
When HMI OP1 with layout <<LAYOUT_MISSION1>> selects grid tab 1
When HMI OP2 with layout <<LAYOUT_MISSION2>> selects grid tab 1
