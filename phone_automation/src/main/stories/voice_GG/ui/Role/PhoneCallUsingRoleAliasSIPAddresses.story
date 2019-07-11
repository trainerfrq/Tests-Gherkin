Narrative:
As an operator
I want to initiate outgoing DA calls towards an another role, using more alias SIP addresses
So I can check that the outgoing call is initiated correctly

Scenario: Booking profiles
Given booked profiles:
| profile | group          | host           | identifier |
| javafx  | hmi            | <<CLIENT1_IP>> | HMI OP1    |
| javafx  | hmi            | <<CLIENT2_IP>> | HMI OP2    |
| javafx  | hmi            | <<CLIENT3_IP>> | HMI OP3    |

Scenario: Define call queue items
Given the call queue items:
| key       | source                      | target                      | callType |
| OP2-OP1-1 | sip:mission2@example.com    | sip:role1@example.com       | DA/IDA   |
| OP2-OP3-1 | sip:mission2@example.com    | sip:role1@example.com       | DA/IDA   |
| OP1-OP2-1 | sip:role1@example.com       |                             | DA/IDA   |
| OP2-OP1-2 | sip:mission2@example.com    | sip:group1@example.com      | DA/IDA   |
| OP2-OP3-2 | sip:mission2@example.com    | sip:group1@example.com      | DA/IDA   |
| OP1-OP2-2 | sip:group1@example.com      |                             | DA/IDA   |
| OP2-OP1-3 | sip:mission2@example.com    | sip:role1alias2@example.com | DA/IDA   |
| OP2-OP3-3 | sip:mission2@example.com    | sip:role1alias2@example.com | DA/IDA   |
| OP1-OP2-3 | sip:role1alias2@example.com |                             | DA/IDA   |
| OP2-OP1-4 | sip:mission2@example.com    | sip:role1alias1@example.com | DA/IDA   |
| OP2-OP3-4 | sip:mission2@example.com    | sip:role1alias1@example.com | DA/IDA   |
| OP1-OP2-4 | sip:role1alias1@example.com |                             | DA/IDA   |
| OP2-OP1-5 | sip:mission2@example.com    | sip:operator1@example.com   | DA/IDA   |
| OP1-OP2-5 | sip:operator1@example.com   |                             | DA/IDA   |

Scenario: Caller opens phonebook
When HMI OP2 with layout <<LAYOUT_MISSION2>> presses function key PHONEBOOK
Then HMI OP2 verifies that phone book call button is disabled

Scenario: Caller selects call route selector
Then HMI OP2 verify that call route selector shows Default
When HMI OP2 selects call route selector: none
Then HMI OP2 verify that call route selector shows None
Then HMI OP2 verifies that phone book call button is disabled

Scenario: Caller writes target address in text box and initiates the call
		  @REQUIREMENTS:GID-2897826
		  @REQUIREMENTS:GID-3030985
When HMI OP2 writes in phonebook text box the address: sip:role1@example.com
Then HMI OP2 verifies that phone book call button is enabled
When HMI OP2 initiates a call from the phonebook

Scenario: Call is initiated
Then HMI OP2 has the call queue item OP1-OP2-1 in state out_ringing
!-- Then HMI OP2 has the call queue item OP1-OP2-1 in the active list with name label Role 1 (Alice)
!-- TODO Enable test when bug QXVP-14392 is fixed
Then HMI OP1 has the call queue item OP2-OP1-1 in state inc_initiated
Then HMI OP1 has the call queue item OP2-OP1-1 in the waiting list with name label mission2
Then HMI OP3 has the call queue item OP2-OP3-1 in the waiting list with name label mission2

Scenario: Caller clears outgoing call
Then HMI OP2 terminates the call queue item OP1-OP2-1

Scenario: Caller opens phonebook
When HMI OP2 with layout <<LAYOUT_MISSION2>> presses function key PHONEBOOK
Then HMI OP2 verifies that phone book call button is disabled

Scenario: Caller selects call route selector
Then HMI OP2 verify that call route selector shows Default
When HMI OP2 selects call route selector: none
Then HMI OP2 verify that call route selector shows None
Then HMI OP2 verifies that phone book call button is disabled

Scenario: Caller writes target address in text box and initiates the call
When HMI OP2 writes in phonebook text box the address: sip:group1@example.com
Then HMI OP2 verifies that phone book call button is enabled
When HMI OP2 initiates a call from the phonebook

Scenario: Call is initiated
Then HMI OP2 has the call queue item OP1-OP2-2 in state out_ringing
!-- Then HMI OP2 has the call queue item OP1-OP2-2 in the active list with name label Group 1
Then HMI OP1 has the call queue item OP2-OP1-2 in state inc_initiated
Then HMI OP1 has the call queue item OP2-OP1-2 in the waiting list with name label mission2
Then HMI OP3 has the call queue item OP2-OP3-2 in the waiting list with name label mission2

Scenario: Caller clears outgoing call
Then HMI OP2 terminates the call queue item OP1-OP2-2

Scenario: Caller opens phonebook
When HMI OP2 with layout <<LAYOUT_MISSION2>> presses function key PHONEBOOK
Then HMI OP2 verifies that phone book call button is disabled

Scenario: Caller selects call route selector
Then HMI OP2 verify that call route selector shows Default
When HMI OP2 selects call route selector: none
Then HMI OP2 verify that call route selector shows None
Then HMI OP2 verifies that phone book call button is disabled

Scenario: Caller writes target address in text box and initiates the call
When HMI OP2 writes in phonebook text box the address: sip:role1alias2@example.com
Then HMI OP2 verifies that phone book call button is enabled
When HMI OP2 initiates a call from the phonebook

Scenario: Call is initiated
Then HMI OP2 has the call queue item OP1-OP2-3 in state out_ringing
!-- Then HMI OP2 has the call queue item OP1-OP2-3 in the active list with name label Role 1 (Alice)
Then HMI OP1 has the call queue item OP2-OP1-3 in state inc_initiated
Then HMI OP1 has the call queue item OP2-OP1-3 in the waiting list with name label mission2
Then HMI OP3 has the call queue item OP2-OP3-3 in the waiting list with name label mission2

Scenario: Caller clears outgoing call
Then HMI OP2 terminates the call queue item OP1-OP2-3

Scenario: Caller opens phonebook
When HMI OP2 with layout <<LAYOUT_MISSION2>> presses function key PHONEBOOK
Then HMI OP2 verifies that phone book call button is disabled

Scenario: Caller selects call route selector
Then HMI OP2 verify that call route selector shows Default
When HMI OP2 selects call route selector: none
Then HMI OP2 verify that call route selector shows None
Then HMI OP2 verifies that phone book call button is disabled

Scenario: Caller writes target address in text box and initiates the call
When HMI OP2 writes in phonebook text box the address: sip:role1alias1@example.com
Then HMI OP2 verifies that phone book call button is enabled
When HMI OP2 initiates a call from the phonebook

Scenario: Call is initiated
Then HMI OP2 has the call queue item OP1-OP2-4 in state out_ringing
!-- Then HMI OP2 has the call queue item OP1-OP2-4 in the active list with name label Role 1 (Alice)
Then HMI OP1 has the call queue item OP2-OP1-4 in state inc_initiated
Then HMI OP1 has the call queue item OP2-OP1-4 in the waiting list with name label mission2
Then HMI OP3 has the call queue item OP2-OP3-4 in the waiting list with name label mission2

Scenario: Caller opens phonebook
When HMI OP2 with layout <<LAYOUT_MISSION2>> presses function key PHONEBOOK
Then HMI OP2 verifies that phone book call button is disabled

Scenario: Caller selects call route selector
Then HMI OP2 verify that call route selector shows Default
When HMI OP2 selects call route selector: none
Then HMI OP2 verify that call route selector shows None
Then HMI OP2 verifies that phone book call button is disabled

Scenario: Caller writes target address in text box and initiates the call
When HMI OP2 writes in phonebook text box the address: sip:operator1@example.com
Then HMI OP2 verifies that phone book call button is enabled
When HMI OP2 initiates a call from the phonebook

Scenario: Call is initiated only towards operator 1
Then HMI OP2 has the call queue item OP1-OP2-5 in state out_ringing
!-- Then HMI OP2 has the call queue item OP1-OP2-5 in the active list with name label sip:operator1@example.com
Then HMI OP1 has the call queue item OP2-OP1-5 in state inc_initiated
Then HMI OP1 has the call queue item OP2-OP1-5 in the waiting list with name label mission2
Then HMI OP3 has in the call queue a number of 0 calls

Scenario: Caller clears outgoing call
Then HMI OP2 terminates the call queue item OP1-OP2-5

Scenario: Call is terminated
Then HMI OP1 has in the call queue a number of 0 calls
Then HMI OP2 has in the call queue a number of 0 calls
Then HMI OP3 has in the call queue a number of 0 calls

