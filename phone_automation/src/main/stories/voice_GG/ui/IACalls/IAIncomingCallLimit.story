Narrative:
As an operator
I want to initiated an outgoing IA call towards an operator with the maximum number of incoming IA calls limit reached
So that I can verify that the IA call will be in state out_failed instead of connected

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
| OP2-OP3 | sip:222222@example.com | sip:op3@example.com    | IA       |

Scenario: Caller establishes an outgoing IA call
When HMI OP1 with layout lower-east-exec-layout selects grid tab 2
When HMI OP1 presses IA key IA - OP2(as OP1)
Then HMI OP1 has the call queue item OP2-OP1 in state connected
Then HMI OP1 has the IA key IA - OP2(as OP1) in state connected

Scenario: Callee receives incoming IA call
When HMI OP2 with layout lower-west-exec-layout selects grid tab 2
Then HMI OP2 has the call queue item OP1-OP2 in state connected
Then HMI OP2 has the IA key IA - OP1 in state connected

Scenario: Op3 establishes another outgoing IA call towards Op2
		  @REQUIREMENTS:GID-2505707
		  @REQUIREMENTS:GID-3236103
When HMI OP3 with layout upper-east-exec-layout selects grid tab 2
Then HMI OP3 has the call queue item OP2-OP3 in state out_failed
Then HMI OP3 has the IA key IA - OP2(as OP3) in state out_failed

Scenario: Op2 has only one item in call queue
Then HMI OP2 has the call queue item OP1-OP2 in state connected
Then HMI OP2 has in the call queue a number of 1 calls

Scenario: Cleanup first IA call
When HMI OP1 presses IA key IA - OP2(as OP1)
Then HMI OP1 has in the call queue a number of 0 calls

Scenario: Call is terminated also for callee
Then HMI OP2 has in the call queue a number of 0 calls

Scenario: Cleanup second IA call
When HMI OP3 presses IA key IA - OP2(as OP3)
Then HMI OP3 has in the call queue a number of 0 calls

Scenario: Cleanup - always select first tab
When HMI OP1 with layout lower-east-exec-layout selects grid tab 1
When HMI OP2 with layout lower-west-exec-layout selects grid tab 1
When HMI OP3 with layout upper-east-exec-layout selects grid tab 1
