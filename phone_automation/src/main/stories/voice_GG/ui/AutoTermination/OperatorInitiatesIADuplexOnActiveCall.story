Narrative:
As an operator having an active phone call
I want to initiate an outgoing IA phone call
So that I can verify that the first phone call is terminated

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
| OP3-OP2 | sip:op3@example.com    | sip:222222@example.com | DA/IDA   |
| OP2-OP3 | sip:222222@example.com | sip:op3@example.com    | DA/IDA   |

Scenario: Caller establishes an outgoing IA call
When HMI OP1 presses IA key IA - OP2(as OP1)
Then HMI OP1 has the call queue item OP2-OP1 in state connected
Then HMI OP1 has the IA key IA - OP2(as OP1) in state connected

Scenario: Callee receives incoming IA call
Then HMI OP2 has the call queue item OP1-OP2 in state connected
Then HMI OP2 has the IA key IA - OP1 in state connected

Scenario: Op3 establishes an outgoing call towards op2
When HMI OP3 presses DA key OP2(as OP3)
Then HMI OP3 has the DA key OP2(as OP3) in state out_ringing

Scenario: Op2 receives the incoming call
Then HMI OP2 has the DA key OP3 in state inc_initiated

Scenario: Op2 answers the incoming call
Then HMI OP2 accepts the call queue item OP3-OP2

Scenario: Verify call state on all operators
Then HMI OP1 has in the call queue a number of 1 calls
Then HMI OP1 has the call queue item OP2-OP1 in state connected
Then HMI OP2 has in the call queue a number of 1 calls
Then HMI OP2 has the call queue item OP1-OP2 in state connected
Then HMI OP2 click on call queue Elements list
Then HMI OP2 has the call queue item OP3-OP2 in state connected
Then HMI OP3 has in the call queue a number of 1 calls
Then HMI OP3 has the call queue item OP2-OP3 in state connected
Then HMI OP2 has in the active list a number of 1 calls
Then HMI OP2 has in the collapsed area a number of 1 calls

Scenario: Op2 also initiates an IA call, transforming the existing IA half duplex call in a full duplex
Then HMI OP2 presses the call queue item OP3-OP2
When HMI OP2 presses IA key IA - OP1

Scenario: Verify calls state on all operators
		  @REQUIREMENTS:GID-2878006
Then HMI OP1 has the IA call queue item OP2-OP1 with audio direction duplex
Then HMI OP2 has the IA call queue item OP1-OP2 with audio direction duplex
Then HMI OP1 has in the call queue a number of 1 calls
Then HMI OP2 has in the call queue a number of 1 calls
Then HMI OP3 has in the call queue a number of 0 calls

Scenario: Caller clears IA call
When HMI OP1 presses IA key IA - OP2(as OP1)

Scenario: Cleanup IA call
When HMI OP2 presses IA key IA - OP1
Then HMI OP2 has in the call queue a number of 0 calls

Scenario: Call is terminated also for callee
Then HMI OP1 has in the call queue a number of 0 calls
