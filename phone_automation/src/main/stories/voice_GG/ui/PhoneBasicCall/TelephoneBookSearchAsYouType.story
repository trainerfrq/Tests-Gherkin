Narrative:
As an operator
I want to search as I type in the telephone book
So I can easily and quickly find a telephone book entry I want to call

Scenario: Define call queue items
Given the call queue items:
| key     | source                   | target                 | callType |
| OP1-OP2 | sip:mission1@example.com | sip:222222@example.com | DA/IDA   |
| OP2-OP1 | sip:222222@example.com   |                        | DA/IDA   |

Scenario: Caller opens phonebook
When HMI OP1 presses function key PHONEBOOK
Then HMI OP1 verifies that phone book call button is disabled
Then HMI OP1 verify that call route selector shows Default

Scenario: Caller does a search in the phone book
		  @REQUIREMENTS:GID-2985359
When HMI OP1 writes in phonebook text box: op
Then HMI OP1 verifies that all phonebook entries have text op highlighted
Then HMI OP1 verifies that phonebook list has 2 items
Then HMI OP1 verifies that phone book call button is enabled

When HMI OP1 writes in phonebook text box: op2
Then HMI OP1 verifies that all phonebook entries have text op2 highlighted
Then HMI OP1 verifies that phonebook list has 1 items

When HMI OP1 selects phonebook entry number: 0
Then HMI OP1 verifies that phone book text box displays text OP2 Physical

When HMI OP1 deletes a character from text box
Then HMI OP1 verifies that phone book text box displays text op
Then HMI OP1 verifies that all phonebook entries have text op highlighted
Then HMI OP1 verifies that phonebook list has 2 items

Scenario: Caller does a call from phone book
When HMI OP1 selects phonebook entry number: 1
When HMI OP1 initiates a call from the phonebook

Scenario: Call is initiated
Then HMI OP1 has the call queue item OP2-OP1 in the active list with label OP2 Physical

Scenario: Caller clears outgoing call
Then HMI OP1 terminates the call queue item OP2-OP1

Scenario: Call is terminated
Then HMI OP1 has in the call queue a number of 0 calls
Then HMI OP2 has in the call queue a number of 0 calls


