As an operator
I want to establish calls using different Call Route Selectors
So I can verify that the elements of the Call Route Selector respect the conversion rules

Scenario: Booking profiles
Given booked profiles:
| profile | group | host           | identifier |
| javafx  | hmi   | <<CLIENT1_IP>> | HMI OP1    |

Scenario: Define call queue items
Given the call queue items:
| key     | source  | target | callType |
| OP2-OP1 | 222222  |        | DA/IDA   |
| 123-OP1 | 123     |        | DA/IDA   |
| 234-OP1 | 234     |        | DA/IDA   |

Scenario: Caller opens phonebook
When HMI OP1 presses function key PHONEBOOK

Scenario: Caller selects call route selector
Then HMI OP1 verify that call route selector shows Default

Scenario: Caller writes target address in text box
When HMI OP1 writes in phonebook text box the address: 222222

Scenario: Caller hits phonebook call button
When HMI OP1 initiates a call from the phonebook

Scenario: Verify call is received and call status is ringing
Then HMI OP1 has the call queue item OP2-OP1 in state out_ringing

Scenario: Caller clears outgoing call
Then HMI OP1 terminates the call queue item OP2-OP1

Scenario: Caller opens phonebook
When HMI OP1 presses function key PHONEBOOK

Scenario: Caller selects call route selector
When HMI OP1 selects call route selector: none
Then HMI OP1 verify that call route selector shows None

Scenario: Caller writes target address in text box
When HMI OP1 writes in phonebook text box the address: 222222

Scenario: Caller hits phonebook call button
When HMI OP1 initiates a call from the phonebook

Scenario: Verify call is received and call status is failed
Then HMI OP1 has the call queue item OP2-OP1 in state out_failed

Scenario: Caller clears outgoing call
Then HMI OP1 terminates the call queue item OP2-OP1

Scenario: Call is terminated
Then HMI OP1 has in the call queue a number of 0 calls

Scenario: Caller opens phonebook
When HMI OP1 presses function key PHONEBOOK

Scenario: Caller selects call route selector
When HMI OP1 selects call route selector: frqUser
Then HMI OP1 verify that call route selector shows FrqUser

Scenario: Caller writes target address in text box
When HMI OP1 writes in phonebook text box the address: 123

Scenario: Caller hits phonebook call button
When HMI OP1 initiates a call from the phonebook

Scenario: Verify call is received and call status is ringing
Then HMI OP1 has the call queue item 123-OP1 in state out_trying

Scenario: Caller clears outgoing call
Then HMI OP1 terminates the call queue item 123-OP1
And wait for 20 seconds

Scenario: Caller opens phonebook
When HMI OP1 presses function key PHONEBOOK

Scenario: Caller selects call route selector
When HMI OP1 selects call route selector: none
Then HMI OP1 verify that call route selector shows None

Scenario: Caller writes target address in text box
When HMI OP1 writes in phonebook text box the address: 123

Scenario: Caller hits phonebook call button
When HMI OP1 initiates a call from the phonebook

Scenario: Verify call is received and call status is failed
Then HMI OP1 has the call queue item 123-OP1 in state out_failed

Scenario: Caller clears outgoing call
Then HMI OP1 terminates the call queue item 123-OP1
And wait for 20 seconds

Scenario: Call is terminated
Then HMI OP1 has in the call queue a number of 0 calls

Scenario: Caller opens phonebook
When HMI OP1 presses function key PHONEBOOK

Scenario: Caller selects call route selector
When HMI OP1 selects call route selector: gmail
Then HMI OP1 verify that call route selector shows Gmail

Scenario: Caller writes target address in text box
When HMI OP1 writes in phonebook text box the address: 234

Scenario: Caller hits phonebook call button
When HMI OP1 initiates a call from the phonebook

Scenario: Verify call is received and call status is ringing
Then HMI OP1 has the call queue item 234-OP1 in state out_trying

Scenario: Caller opens phonebook
When HMI OP1 presses function key PHONEBOOK

Scenario: Caller selects call route selector
When HMI OP1 selects call route selector: none
Then HMI OP1 verify that call route selector shows None

Scenario: Caller writes target address in text box
When HMI OP1 writes in phonebook text box the address: 234

Scenario: Caller hits phonebook call button
When HMI OP1 initiates a call from the phonebook

Scenario: Verify call is received and call status is failed
Then HMI OP1 has the call queue item 234-OP1 in state out_failed

Scenario: Caller clears outgoing call
Then HMI OP1 terminates the call queue item 234-OP1
And wait for 30 seconds

Scenario: Call is terminated
Then HMI OP1 has in the call queue a number of 0 calls

