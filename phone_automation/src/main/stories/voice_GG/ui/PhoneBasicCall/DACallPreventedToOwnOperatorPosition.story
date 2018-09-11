Narrative:
As a user caller operator
I want to initiate an outgoing DA call to own operator position
So I can verify that the operator doesn't have an incoming call.

Scenario: Booking profiles
Given booked profiles:
| profile | group | host           | identifier |
| javafx  | hmi   | <<CLIENT1_IP>> | HMI OP1    |

Scenario: Define call queue items
Given the call queue items:
| key     | source   | target | callType |
| OP1-OP1 | 111111   |        | DA/IDA   |

Scenario: Caller opens phonebook
When HMI OP1 presses function key PHONEBOOK

Scenario: Caller writes target address in text box
When HMI OP1 writes in phonebook text box the address: 111111

Scenario: Caller hits phonebook call button
When HMI OP1 initiates a call from the phonebook

Scenario: Verify call is received and call status isfailed
		  @REQUIREMENTS:GID-2535698
Then HMI OP1 has in the call queue a number of 1 calls
Then HMI OP1 has the call queue item OP1-OP1 in state out_failed

Scenario: Caller clears outgoing call
Then HMI OP1 terminates the call queue item OP1-OP1

Scenario: Call is terminated
Then HMI OP1 has in the call queue a number of 0 calls