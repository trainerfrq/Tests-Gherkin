Narrative:
As an operator
I want to initiate an outgoing DA call with the Dial Pad using ATS telephone number
So I can check that the outgoing call is initiated

Scenario: Booking profiles
Given booked profiles:
| profile | group | host           | identifier |
| javafx  | hmi   | <<CLIENT1_IP>> | HMI OP1    |
| javafx  | hmi   | <<CLIENT2_IP>> | HMI OP2    |

Scenario: Define call queue items
Given the call queue items:
| key     | source                   | target                 | callType |
| OP1-OP2 | sip:mission1@example.com | sip:222222@example.com | DA/IDA   |
| OP2-OP1 | 222222                   |                        | DA/IDA   |

Scenario: Caller opens phonebook
When HMI OP1 presses function key PHONEBOOK
Then HMI OP1 verify that call route selector shows Default
Then HMI OP1 verifies that phone book call button is disabled

Scenario: Caller writes target address in text box
When HMI OP1 writes in phonebook text box the address: 222222
Then HMI OP1 verifies that phone book call button is enabled

Scenario: Caller hits phonebook call button
		  @REQUIREMENTS:GID-2535727
		  @REQUIREMENTS:GID-2535740
		  @REQUIREMENTS:GID-2536683
When HMI OP1 initiates a call from the phonebook
Then waiting for 1 second

Scenario: Call is initiated
		  @REQUIREMENTS:GID-2932446
Then HMI OP1 has the call queue item OP2-OP1 in state out_ringing
!-- Then HMI OP1 has the call queue item OP2-OP1 in the active list with label OP2 Physical
Then HMI OP2 has the call queue item OP1-OP2 in state ringing
Then HMI OP2 has the call queue item OP1-OP2 in the waiting list with label mission1

Scenario: Callee accepts call
Then HMI OP2 accepts the call queue item OP1-OP2
Then HMI OP2 has the call queue item OP1-OP2 in the active list with label mission1

Scenario: Caller clears outgoing call
Then HMI OP1 terminates the call queue item OP2-OP1

Scenario: Call is terminated
Then HMI OP1 has in the call queue a number of 0 calls
Then HMI OP2 has in the call queue a number of 0 calls
