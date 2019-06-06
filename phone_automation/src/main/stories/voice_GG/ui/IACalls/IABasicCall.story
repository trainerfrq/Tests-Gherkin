Narrative:
As an operator
I want to initiate an outgoing IA call towards another operator
So that I can verify that the IA call is automatically accepted by the other operator

Scenario: Booking profiles
Given booked profiles:
| profile | group | host           | identifier |
| javafx  | hmi   | <<CLIENT1_IP>> | HMI OP1    |
| javafx  | hmi   | <<CLIENT2_IP>> | HMI OP2    |

Scenario: Define call queue items
Given the call queue items:
| key     | source                 | target                 | callType |
| OP1-OP2 | sip:111111@example.com | sip:222222@example.com | IA       |
| OP2-OP1 | sip:222222@example.com | sip:111111@example.com | IA       |

Scenario: Caller establishes an outgoing IA call
		  @REQUIREMENTS:GID-2505705
		  @REQUIREMENTS:GID-2505706
When HMI OP1 selects grid tab 2
Then HMI OP1 has the call queue item OP2-OP1 in state connected
Then HMI OP1 has the IA key IA - OP2(as OP1) in state connected

Scenario: Callee receives incoming IA call
		  @REQUIREMENTS:GID-2505708
		  @REQUIREMENTS:GID-2512204
Then HMI OP2 has the call queue item OP1-OP2 in state connected
When HMI OP2 selects grid tab 2
Then HMI OP2 has the IA key IA - OP1 in state connected

Scenario: Cleanup IA call
When HMI OP1 presses IA key IA - OP2(as OP1)
Then HMI OP1 has in the call queue a number of 0 calls

Scenario: Call is terminated also for callee
Then HMI OP2 has in the call queue a number of 0 calls

Scenario: Cleanup - always select first tab
When HMI OP1 selects grid tab 1
When HMI OP2 selects grid tab 1