Narrative:
As an operator
I want to initiate an outgoing DA call with the Dial Pad using alphanumeric address
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
| OP2-OP1 | sip:222222@example.com   |                        | DA/IDA   |

Scenario: Caller opens phonebook
When HMI OP1 with layout lower-east-exec-layout presses function key PHONEBOOK
Then HMI OP1 verifies that phone book call button is disabled

Scenario: Caller selects call route selector
		  @REQUIREMENTS:GID-2985359
Then HMI OP1 verify that call route selector shows Default
When HMI OP1 selects call route selector: none
Then HMI OP1 verify that call route selector shows None
Then HMI OP1 verifies that phone book call button is disabled

Scenario: Caller writes target address in text box
When HMI OP1 writes in phonebook text box the address: sip:222222@example.com
Then HMI OP1 verifies that phone book call button is enabled

Scenario: Caller hits phonebook call button
		  @REQUIREMENTS:GID-4020711
		  @REQUIREMENTS:GID-2535740
		  @REQUIREMENTS:GID-2536683
When HMI OP1 initiates a call from the phonebook

Scenario: Call is initiated
		  @REQUIREMENTS:GID-2535717
		  @REQUIREMENTS:GID-2536683
		  @REQUIREMENTS:GID-2505643
		  @REQUIREMENTS:GID-2535740
		  @REQUIREMENTS:GID-3366402
Then HMI OP1 has the call queue item OP2-OP1 in state out_ringing
!-- Then HMI OP1 has the call queue item OP2-OP1 in the active list with name label OP2 Physical
!-- TODO Enable test when bug QXVP-14392 is fixed
Then HMI OP2 has the call queue item OP1-OP2 in the waiting list with name label mission1
Then HMI OP2 has the call queue item OP1-OP2 in state inc_initiated

Scenario: Caller clears outgoing call
Then HMI OP1 terminates the call queue item OP2-OP1

Scenario: Call is terminated
Then HMI OP1 has in the call queue a number of 0 calls
Then HMI OP2 has in the call queue a number of 0 calls
