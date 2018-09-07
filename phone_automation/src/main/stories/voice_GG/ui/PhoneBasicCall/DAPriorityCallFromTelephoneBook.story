Narrative:
As an operator
I want to initiate an outgoing DA call by clicking on one telephone book entry
So I can check that the call towards the corresponding entry is initiated

Scenario: Booking profiles
Given booked profiles:
| profile | group | host           | identifier |
| javafx  | hmi   | <<CLIENT1_IP>> | HMI OP1    |
| javafx  | hmi   | <<CLIENT3_IP>> | HMI OP3    |

Scenario: Define call queue items
Given the call queue items:
| key     | source                   | target                 | callType |
| OP1-OP3 | sip:mission1@example.com | <<OPVOICE3_PHONE_URI>> | DA/IDA   |
| OP3-OP1 | <<OPVOICE3_PHONE_URI>>   |                        | DA/IDA   |

Scenario: Caller opens phonebook
When HMI OP1 presses function key PHONEBOOK

Scenario: Caller selects call route selector
When HMI OP1 selects call route selector: None

Scenario: Caller selects item from phonebook
When HMI OP1 selects phonebook entry number: 2

Scenario: Caller toggles priority
When HMI OP1 toggles call priority

Scenario: Caller hits phonebook call button
When HMI OP1 initiates a call from the phonebook

Scenario: Priority call is initiated
Then HMI OP1 has in the call queue the item OP3-OP1 with priority
Then HMI OP1 has the call queue item OP3-OP1 in the active list with label Lloyd

Scenario: Caller clears outgoing call
Then HMI OP1 terminates the call queue item OP3-OP1

Scenario: Call is terminated
Then HMI OP1 has in the call queue a number of 0 calls
Then HMI OP3 has in the call queue a number of 0 calls
