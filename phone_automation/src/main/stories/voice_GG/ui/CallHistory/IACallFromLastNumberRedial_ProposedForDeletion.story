Narrative:
As an operator
I want to initiate an outgoing IA call redialing the previous IA call
So I can check that the IA call is initiated to the destination according to the previous IA call

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

Scenario: OP1 establishes an outgoing IA call
When HMI OP1 presses IA key IA - OP2(as OP1)
Then HMI OP1 has the call queue item OP2-OP1 in state connected
Then HMI OP1 has the IA key IA - OP2(as OP1) in state connected

Scenario: OP2 receives incoming IA call
Then HMI OP2 has the call queue item OP1-OP2 in state connected
Then HMI OP2 has the IA key IA - OP1 in state connected

Scenario: Cleanup IA call
When HMI OP1 presses IA key IA - OP2(as OP1)
Then HMI OP1 has in the call queue a number of 0 calls

Scenario: Call is terminated also for callee
Then HMI OP2 has in the call queue a number of 0 calls

Scenario: OP1 opens call history
When HMI OP1 presses function key CALLHISTORY

Scenario: Caller selects first entry from history
When HMI OP1 selects call history list entry number: 0

Scenario: OP2 receives incoming IA call
Then HMI OP2 has the call queue item OP1-OP2 in state connected
Then HMI OP2 has the IA key IA - OP1 in state connected

Scenario: Cleanup IA call
When HMI OP1 presses IA key IA - OP2(as OP1)
Then HMI OP1 has in the call queue a number of 0 calls

Scenario: OP1 opens call history
When HMI OP1 presses function key CALLHISTORY

Scenario: OP1 redials last number
		  @REQUIREMENTS:GID-2535779
		  @REQUIREMENTS:GID-2535786
		  @REQUIREMENTS:GID-2505706
When HMI OP1 redials last number
Then HMI OP1 has the call queue item OP2-OP1 in state connected
Then HMI OP1 has the IA key IA - OP2(as OP1) in state connected

Scenario: OP2 receives incoming IA call
Then HMI OP2 has the call queue item OP1-OP2 in state connected
Then HMI OP2 has the IA key IA - OP1 in state connected

Scenario: Cleanup IA call
When HMI OP1 presses IA key IA - OP2(as OP1)
Then HMI OP1 has in the call queue a number of 0 calls

Scenario: Call is terminated also for callee
Then HMI OP2 has in the call queue a number of 0 calls
