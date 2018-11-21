Narrative:
As an operator
I want to initiate outgoing DA calls towards same role, using primary and alias SIP address
So I can check that the outgoing call is initiated

Scenario: Booking profiles
Given booked profiles:
| profile | group | host           | identifier |
| javafx  | hmi   | <<CLIENT1_IP>> | HMI OP1    |
| javafx  | hmi   | <<CLIENT2_IP>> | HMI OP2    |

Scenario: Define call queue items
Given the call queue items:
| key       | source                   | target                      | callType |
| OP1-OP2-1 | sip:mission1@example.com | sip:role2@example.com       | DA/IDA   |
| OP2-OP1-1 | sip:222222@example.com   |                             | DA/IDA   |
| OP1-OP2-2 | sip:mission1@example.com | sip:group1@example.com      | DA/IDA   |
| OP2-OP1-2 | sip:222222@example.com   |                             | DA/IDA   |
| OP1-OP2-3 | sip:mission1@example.com | sip:role2alias2@example.com | DA/IDA   |
| OP2-OP1-3 | sip:222222@example.com   |                             | DA/IDA   |
| OP1-OP2-4 | sip:mission1@example.com | sip:role2alias1@example.com | DA/IDA   |
| OP2-OP1-4 | sip:222222@example.com   |                             | DA/IDA   |


Scenario: Caller opens phonebook
When HMI OP1 presses function key PHONEBOOK
Then HMI OP1 verifies that phone book call button is disabled

Scenario: Caller selects call route selector
Then HMI OP1 verify that call route selector shows Default
When HMI OP1 selects call route selector: none
Then HMI OP1 verify that call route selector shows None
Then HMI OP1 verifies that phone book call button is disabled

Scenario: Caller writes target address in text box (primary addresss)
		  @REQUIREMENTS:GID-2952544
		  @REQUIREMENTS:GID-2897826
		  @REQUIREMENTS:GID-3030985
When HMI OP1 writes in phonebook text box the address: sip:role2@example.com
Then HMI OP1 verifies that phone book call button is enabled
When HMI OP1 initiates a call from the phonebook

Scenario: Call is initiated
Then HMI OP1 has the call queue item OP2-OP1-1 in state out_ringing
Then HMI OP1 has the call queue item OP2-OP1-1 in the active list with label sip:role2@example.com
Then HMI OP2 has the call queue item OP1-OP2-1 in state ringing

Scenario: Caller clears outgoing call
Then HMI OP1 terminates the call queue item OP2-OP1-1

Scenario: Caller opens phonebook
When HMI OP1 presses function key PHONEBOOK
Then HMI OP1 verifies that phone book call button is disabled

Scenario: Caller selects call route selector
Then HMI OP1 verify that call route selector shows Default
When HMI OP1 selects call route selector: none
Then HMI OP1 verify that call route selector shows None
Then HMI OP1 verifies that phone book call button is disabled

Scenario: Caller writes target address in text box (alias address)
When HMI OP1 writes in phonebook text box the address: sip:group1@example.com
Then HMI OP1 verifies that phone book call button is enabled
When HMI OP1 initiates a call from the phonebook

Scenario: Call is initiated
Then HMI OP1 has the call queue item OP2-OP1-2 in state out_ringing
Then HMI OP1 has the call queue item OP2-OP1-2 in the active list with label sip:group1@example.com
Then HMI OP2 has the call queue item OP1-OP2-2 in state ringing

Scenario: Caller clears outgoing call
Then HMI OP1 terminates the call queue item OP2-OP1-2

Scenario: Caller opens phonebook
When HMI OP1 presses function key PHONEBOOK
Then HMI OP1 verifies that phone book call button is disabled

Scenario: Caller selects call route selector
Then HMI OP1 verify that call route selector shows Default
When HMI OP1 selects call route selector: none
Then HMI OP1 verify that call route selector shows None
Then HMI OP1 verifies that phone book call button is disabled

Scenario: Caller writes target address in text box (alias address)
When HMI OP1 writes in phonebook text box the address: sip:role2alias2@example.com
Then HMI OP1 verifies that phone book call button is enabled
When HMI OP1 initiates a call from the phonebook

Scenario: Call is initiated
Then HMI OP1 has the call queue item OP2-OP1-3 in state out_ringing
Then HMI OP1 has the call queue item OP2-OP1-3 in the active list with label sip:role2alias2@example.com
Then HMI OP2 has the call queue item OP1-OP2-3 in state ringing

Scenario: Caller clears outgoing call
Then HMI OP1 terminates the call queue item OP2-OP1-3

Scenario: Caller opens phonebook
When HMI OP1 presses function key PHONEBOOK
Then HMI OP1 verifies that phone book call button is disabled

Scenario: Caller selects call route selector
Then HMI OP1 verify that call route selector shows Default
When HMI OP1 selects call route selector: none
Then HMI OP1 verify that call route selector shows None
Then HMI OP1 verifies that phone book call button is disabled

Scenario: Caller writes target address in text box (alias address)
When HMI OP1 writes in phonebook text box the address: sip:role2alias1@example.com
Then HMI OP1 verifies that phone book call button is enabled
When HMI OP1 initiates a call from the phonebook

Scenario: Call is initiated
Then HMI OP1 has the call queue item OP2-OP1-4 in state out_ringing
Then HMI OP1 has the call queue item OP2-OP1-4 in the active list with label sip:role2alias1@example.com
Then HMI OP2 has the call queue item OP1-OP2-4 in state ringing

Scenario: Caller clears outgoing call
Then HMI OP1 terminates the call queue item OP2-OP1-4

Scenario: Call is terminated
Then HMI OP1 has in the call queue a number of 0 calls
Then HMI OP2 has in the call queue a number of 0 calls
