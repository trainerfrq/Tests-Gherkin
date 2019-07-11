Narrative:
As an operator having in the call queue a call on hold
I want to enter a Call Forward loop
So I can verify that the call on hold can be retrieved

Scenario: Booking profiles
Given booked profiles:
| profile | group | host           | identifier |
| javafx  | hmi   | <<CLIENT1_IP>> | HMI OP1    |
| javafx  | hmi   | <<CLIENT2_IP>> | HMI OP2    |
| javafx  | hmi   | <<CLIENT3_IP>> | HMI OP3    |

Scenario: Define call queue items
Given the call queue items:
| key     | source                 | target                 | callType |
| OP3-OP2 | sip:op3@example.com    | sip:222222@example.com | DA/IDA   |
| OP2-OP3 | sip:222222@example.com | sip:op3@example.com    | DA/IDA   |

Scenario: Op3 establishes an outgoing call towards Op2
When HMI OP3 presses DA key OP2(as OP3)
When HMI OP2 presses DA key OP3
Then HMI OP3 has the call queue item OP2-OP3 in state connected
Then HMI OP2 has the call queue item OP3-OP2 in state connected

Scenario: Op2 puts call on hold
When HMI OP2 puts on hold the active call
Then HMI OP2 has the call queue item OP3-OP2 in state hold
Then HMI OP3 has the call queue item OP2-OP3 in state held

Scenario: Op1 activates Call Forward with Op2 as call forward target
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key CALLFORWARD
When HMI OP1 presses DA key OP2(as OP1)
Then HMI OP1 with layout <<LAYOUT_MISSION1>> has the function key CALLFORWARD in active state

Scenario: Op2 activates Call Forward with Op1 as call forward target
		  @REQUIREMENTS:GID-2541807
		  @REQUIREMENTS:GID-4370514
When HMI OP2 with layout <<LAYOUT_MISSION2>> presses function key CALLFORWARD
When HMI OP2 presses DA key OP1
Then HMI OP2 with layout <<LAYOUT_MISSION2>> has the function key CALLFORWARD in active state

Scenario: Op2 retrieves call from hold
		  @REQUIREMENTS:GID-2510075
Then HMI OP2 retrieves from hold the call queue item OP3-OP2

Scenario: Verify call is connected
Then HMI OP3 has the call queue item OP2-OP3 in state connected
Then HMI OP2 has the call queue item OP3-OP2 in state connected

Scenario: Op2 clears the call
Then HMI OP2 terminates the call queue item OP3-OP2
Then HMI OP2 has in the call queue a number of 0 calls
Then HMI OP3 has in the call queue a number of 0 calls

Scenario: Op1 deactivates Call Forward
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key CALLFORWARD
Then HMI OP1 verifies that call queue info container is not visible

Scenario: Op2 deactivates Call Forward
When HMI OP2 with layout <<LAYOUT_MISSION2>> presses function key CALLFORWARD
Then HMI OP2 verifies that call queue info container is not visible
