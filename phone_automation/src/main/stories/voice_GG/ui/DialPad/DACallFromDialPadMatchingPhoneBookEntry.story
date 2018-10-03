Narrative:
As an operator
I want to initiate an outgoing DA call with the Dial Pad using a SIP URI with a matching phonebook entry
So I can check that the corresponding telephone book entry is displayed on the calling operators position

Scenario: Booking profiles
Given booked profiles:
| profile | group | host           | identifier |
| javafx  | hmi   | <<CLIENT1_IP>> | HMI OP1    |
| javafx  | hmi   | <<CLIENT3_IP>> | HMI OP3    |

Scenario: Define call queue items
Given the call queue items:
| key     | source                   | target              | callType |
| OP1-OP3 | sip:mission1@example.com | sip:op3@example.com | DA/IDA   |
| OP3-OP1 | sip:op3@example.com      |                     | DA/IDA   |

Scenario: Caller opens phonebook
When HMI OP1 presses function key PHONEBOOK
Then HMI OP1 verifies that phone book call button is disabled

Scenario: Caller selects call route selector
		  @REQUIREMENTS:GID-2985359
Then HMI OP1 verify that call route selector shows Default
When HMI OP1 selects call route selector: none
Then HMI OP1 verify that call route selector shows None
Then HMI OP1 verifies that phone book call button is disabled

Scenario: Caller writes target address in text box
When HMI OP1 writes in phonebook text box the address: <<OPVOICE3_PHONE_URI>>
Then HMI OP1 verifies that phone book call button is enabled

Scenario: Caller hits phonebook call button
When HMI OP1 initiates a call from the phonebook

Scenario: Call is initiated
		  @REQUIREMENTS:GID-2877904
		  @REQUIREMENTS:GID-2932446
!-- TODO QXVP-10847 : re-enable this test after bug is fixed
Then HMI OP1 has the call queue item SipContact-OP1 in the active list with label Lloyd

Scenario: Caller clears outgoing call
Then HMI OP1 terminates the call queue item OP3-OP1

Scenario: Call is terminated
Then HMI OP1 has in the call queue a number of 0 calls
Then HMI OP3 has in the call queue a number of 0 calls
