Narrative:
As an operator having an active IA full duplex call
I want to initiate an another IA call
So that I can verify that the first outgoing IA call is terminated

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

Scenario: Caller establishes an outgoing IA call
When HMI OP2 presses IA key IA - OP1
Then HMI OP2 has the call queue item OP1-OP2 in state connected

Scenario: Callee receives incoming IA call
Then HMI OP1 has the call queue item OP2-OP1 in state connected

Scenario: Callee also initiate a IA call, transforming the existing IA half duplex call in a full duplex
When HMI OP1 presses IA key IA - OP2(as OP1)

Scenario: Verify calls state on all operators
Then HMI OP1 has the IA call queue item OP2-OP1 with audio direction duplex
Then HMI OP2 has the IA call queue item OP1-OP2 with audio direction duplex
Then HMI OP1 has in the call queue a number of 1 calls
Then HMI OP2 has in the call queue a number of 1 calls

Scenario: Caller establishes an another outgoing IA call
When HMI OP2 presses IA key IA - OP3
Then HMI OP2 click on call queue Elements list
Then HMI OP2 has the call queue item OP3-OP2 in state connected
Then HMI OP2 has the IA key IA - OP3 in state connected

Scenario: Callee receives incoming IA call
Then HMI OP3 has the call queue item OP2-OP3 in state connected

Scenario: Verify calls state for all operators
		  @REQUIREMENTS:GID-2878005
          @REQUIREMENTS:GID-2878006
Then HMI OP3 has the call queue item OP2-OP3 in state connected
Then HMI OP2 click on call queue Elements list
Then HMI OP2 has the call queue item OP3-OP2 in state connected
Then HMI OP2 has the IA call queue item OP1-OP2 with audio direction rx
Then HMI OP2 has the IA call queue item OP3-OP2 with audio direction tx
Then HMI OP1 has the IA call queue item OP2-OP1 with audio direction tx
Then HMI OP3 has the IA call queue item OP2-OP3 with audio direction rx
Then HMI OP1 has in the call queue a number of 1 calls
Then HMI OP2 has in the call queue a number of 2 calls
Then HMI OP3 has in the call queue a number of 1 calls

Scenario: Op1 clears first IA call
When HMI OP1 presses IA key IA - OP2(as OP1)

Scenario: Verify calls state for all operators
Then HMI OP3 has the call queue item OP2-OP3 in state connected
Then HMI OP2 has the call queue item OP3-OP2 in state connected
Then HMI OP1 has in the call queue a number of 0 calls
Then HMI OP2 has in the call queue a number of 1 calls
Then HMI OP3 has in the call queue a number of 1 calls

Scenario: Op2 clears second IA call
When HMI OP2 presses IA key IA - OP3

Scenario: Verify call state for both operators
Then HMI OP2 has in the call queue a number of 0 calls
Then HMI OP3 has in the call queue a number of 0 calls
