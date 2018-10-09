Narrative:
As a caller operator having to leave temporarily my Operator Position
I want to activate CallForward
So I can verify that all IA phone calls are forwarded to the selected (forward) target Operator Position

Scenario: Booking profiles
Given booked profiles:
| profile | group | host           | identifier |
| javafx  | hmi   | <<CLIENT1_IP>> | HMI OP1    |
| javafx  | hmi   | <<CLIENT2_IP>> | HMI OP2    |
| javafx  | hmi   | <<CLIENT3_IP>> | HMI OP3    |

Scenario: Define call queue items
Given the call queue items:
| key     | source                 | target                 | callType |
| OP1-OP2 | sip:111111@example.com | sip:222222@example.com | IA       |
| OP2-OP1 | sip:222222@example.com | sip:111111@example.com | IA       |
| OP3-OP2 | sip:op3@example.com    | sip:222222@example.com | IA       |
| OP2-OP3 | sip:222222@example.com | sip:op3@example.com    | IA       |

Scenario: Op1 activates Call Forward
When HMI OP1 presses function key CALLFORWARD
Then HMI OP1 is in forward_ongoing state
Then HMI OP1 verifies that call queue info container is not visible

Scenario: Op1 chooses Op3 as call forward target
		  REQUIREMENTS:GID-2521111
When HMI OP1 presses DA key OP3(as OP1)
Then HMI OP1 is in forward_active state
Then HMI OP1 verifies that call queue info container is visible
Then HMI OP1 verifies that call queue info container contains Target: op3
Then HMI OP1 has in the call queue a number of 0 calls
Then HMI OP3 has in the call queue a number of 0 calls

Scenario: Op2 establishes an outgoing IA call
When HMI OP2 presses IA key IA - OP1
Then HMI OP2 has the IA key IA - OP1 in state connected

Scenario: Call is automatically forwarded to Op3
		  REQUIREMENTS:GID-2521112
Then HMI OP3 has in the call queue a number of 1 calls
Then HMI OP3 has the IA key IA - OP2(as OP3) in state connected

Scenario: Verify call is connected for both operators
Then HMI OP2 has the call queue item OP1-OP2 in state connected
Then HMI OP3 has the call queue item OP2-OP3 in state connected
Then HMI OP1 has in the call queue a number of 0 calls
Then HMI OP1 is in forward_active state

Scenario: Op2 client clears the phone call
When HMI OP2 presses IA key IA - OP1
Then HMI OP2 has in the call queue a number of 0 calls

Scenario: Call is terminated also for Op3
Then HMI OP3 has in the call queue a number of 0 calls

Scenario: Op1 still has Call Forward active
Then HMI OP1 is in forward_active state

Scenario: Op1 deactivates Call Forward
When HMI OP1 presses function key CALLFORWARD
Then HMI OP1 verifies that call queue info container is not visible



