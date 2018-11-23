Narrative:
As a caller operator having Call Forward active
I want to make an outgoing call
So I can verify that call can be done while Call Forward is active

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
| OP1-OP3 | sip:111111@example.com | sip:op3@example.com    | DA/IDA   |
| OP3-OP1 | sip:op3@example.com    | sip:111111@example.com | DA/IDA   |

Scenario: Op1 activates Call Forward
When HMI OP1 presses function key CALLFORWARD
Then HMI OP1 has the function key CALLFORWARD in forwardOngoingState state

Scenario: Op1 chooses Op2 as call forward target
		  @REQUIREMENTS:GID-2521111
When HMI OP1 presses DA key OP2(as OP1)
Then HMI OP1 has the function key CALLFORWARD in forwardActiveState state
Then HMI OP1 verifies that call queue info container is visible
Then HMI OP1 has in the call queue a number of 0 calls
Then HMI OP2 has in the call queue a number of 0 calls

Scenario: Op1 establishes an outgoing call
When HMI OP1 presses DA key OP3(as OP1)
Then HMI OP1 has the DA key OP3(as OP1) in state out_ringing

Scenario: Op3 receives the incoming call
Then HMI OP3 has the DA key OP1(as OP3) in state inc_initiated

Scenario: Op3 client answers the incoming call
When HMI OP3 presses DA key OP1(as OP3)

Scenario: Verify call is connected for both operators
Then HMI OP1 has the call queue item OP3-OP1 in state connected
Then HMI OP3 has the call queue item OP1-OP3 in state connected
Then HMI OP2 has in the call queue a number of 0 calls

Scenario: Op1 client clears the phone call
When HMI OP1 presses DA key OP3(as OP1)
Then HMI OP1 has in the call queue a number of 0 calls
Then HMI OP3 has in the call queue a number of 0 calls

Scenario: Op1 still has Call Forward active
Then HMI OP1 has the function key CALLFORWARD in forwardActiveState state
Then HMI OP1 verifies that call queue info container is visible

Scenario: Op1 establishes an outgoing priority call
When HMI OP1 initiates a priority call on DA key OP3(as OP1)
Then HMI OP1 has the DA key OP3(as OP1) in state out_ringing

Scenario: Op3 receives the incoming priority call
Then HMI OP3 has the DA key OP1(as OP3) in state inc_initiated
Then HMI OP3 has in the call queue the item OP1-OP3 with priority

Scenario: Op3 client answers the incoming call
When HMI OP3 presses DA key OP1(as OP3)

Scenario: Verify priority call is connected for both operators
Then HMI OP1 has the call queue item OP3-OP1 in state connected
Then HMI OP3 has the call queue item OP1-OP3 in state connected
Then HMI OP1 verifies that call queue item bar signals call state priority
Then HMI OP3 verifies that call queue item bar signals call state priority
Then HMI OP2 has in the call queue a number of 0 calls

Scenario: Op1 client clears the priority call
When HMI OP1 presses DA key OP3(as OP1)
Then HMI OP1 has in the call queue a number of 0 calls
Then HMI OP3 has in the call queue a number of 0 calls

Scenario: Op1 still has Call Forward active
Then HMI OP1 has the function key CALLFORWARD in forwardActiveState state
Then HMI OP1 verifies that call queue info container is visible

Scenario: Op1 establishes an outgoing IA call
When HMI OP1 presses IA key IA - OP2(as OP1)
Then HMI OP1 has the call queue item OP2-OP1 in state connected
Then HMI OP1 has the IA key IA - OP2(as OP1) in state connected

Scenario: Op1 receives incoming IA call
Then HMI OP2 has the call queue item OP1-OP2 in state connected
Then HMI OP2 has the IA key IA - OP1 in state connected

Scenario: Cleanup IA call
When HMI OP1 presses IA key IA - OP2(as OP1)
Then HMI OP1 has in the call queue a number of 0 calls

Scenario: Call is terminated also for op2
Then HMI OP2 has in the call queue a number of 0 calls

Scenario: Op1 still has Call Forward active
Then HMI OP1 has the function key CALLFORWARD in forwardActiveState state

Scenario: Op1 deactivates Call Forward
When HMI OP1 presses function key CALLFORWARD
Then HMI OP1 verifies that call queue info container is not visible


