Narrative:
As a caller operator having to leave temporarily my Operator Position
I want to activate CallForward
So I can verify that all DA priority calls are forwarded to the selected target Operator Position

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
| OP1-OP3 | sip:111111@example.com | sip:op3@example.com    | DA/IDA   |
| OP3-OP1 | sip:op3@example.com    | sip:111111@example.com | DA/IDA   |

Scenario: Op1 activates Call Forward
When HMI OP1 presses function key CALLFORWARD
Then HMI OP1 is in forward_ongoing state
Then HMI OP1 verifies that call queue info container is not visible

Scenario: Op1 chooses Op2 as call forward target
		  @REQUIREMENTS:GID-2521111
When HMI OP1 presses DA key OP2(as OP1)
Then HMI OP1 is in forward_active state
Then HMI OP1 verifies that call queue info container is visible
Then HMI OP1 verifies that call queue info container contains Target: OP2 Physical
Then HMI OP1 has in the call queue a number of 0 calls
Then HMI OP2 has in the call queue a number of 0 calls

Scenario: Op3 establishes an outgoing priority call
When HMI OP3 initiates a priority call on DA key OP1(as OP3)
Then HMI OP3 has the DA key OP1(as OP3) in state out_ringing

Scenario: Priority call is automatically forwarded to Op2
		  @REQUIREMENTS:GID-2521112
Then HMI OP1 has in the call queue a number of 0 calls
Then HMI OP2 has the DA key OP3 in state ringing
Then HMI OP2 has in the call queue the item OP3-OP2 with priority

Scenario: Op2 client answers the incoming call
When HMI OP2 presses DA key OP3

Scenario: Verify priority call is connected for both operators
Then HMI OP2 has the call queue item OP3-OP2 in state connected
Then HMI OP3 has the call queue item OP1-OP3 in state connected
Then HMI OP3 has in the call queue the item OP1-OP3 with priority
Then HMI OP1 has in the call queue a number of 0 calls
Then HMI OP1 is in forward_active state

Scenario: Op3 client clears the phone call
When HMI OP3 presses DA key OP1(as OP3)
Then HMI OP3 has in the call queue a number of 0 calls

Scenario: Call is terminated also for Op2
Then HMI OP2 has in the call queue a number of 0 calls

Scenario: Op1 still has Call Forward active
Then HMI OP1 is in forward_active state
Then HMI OP1 verifies that call queue info container contains Press to de-activate...

Scenario: Op1 deactivates Call Forward
When HMI OP1 deactivates call forward by pressing on the call queue info
Then HMI OP1 verifies that call queue info container is not visible


