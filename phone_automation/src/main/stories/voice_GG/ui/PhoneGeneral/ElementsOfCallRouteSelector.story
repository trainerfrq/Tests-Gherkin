As an operator
I want to establish calls using different Call Route Selectors
So I can verify that the elements of the Call Route Selector respect the conversion rules

Scenario: Booking profiles
Given booked profiles:
| profile | group | host           | identifier |
| javafx  | hmi   | <<CLIENT1_IP>> | HMI OP1    |

Scenario: Define call queue items
Given the call queue items:
| key       | source  | target | callType |
| OP2-OP1   | 222222  |        | DA/IDA   |
| 2-OP1     | 22222   |        | DA/IDA   |
| 22-OP1    | 2222    |        | DA/IDA   |
| 222-OP1   | 222     |        | DA/IDA   |
| 2222-OP1  | 22      |        | DA/IDA   |
| 22222-OP1 | 2       |        | DA/IDA   |

Scenario: Caller initiates a call with Call Route Selector None
When HMI OP1 presses function key PHONEBOOK
When HMI OP1 selects call route selector: none
Then HMI OP1 verify that call route selector shows None
When HMI OP1 writes in phonebook text box the address: 222222
When HMI OP1 initiates a call from the phonebook
Then HMI OP1 has the call queue item OP2-OP1 in state out_failed
Then HMI OP1 terminates the call queue item OP2-OP1
Then HMI OP1 has in the call queue a number of 0 calls

Scenario: Caller initiates a call with Call Route Selector Default
When HMI OP1 presses function key PHONEBOOK
Then HMI OP1 verify that call route selector shows Default
When HMI OP1 writes in phonebook text box the address: 222222
When HMI OP1 initiates a call from the phonebook
Then HMI OP1 has the call queue item OP2-OP1 in state out_ringing

Scenario: Caller initiates a call with Call Route Selector FrqUser
When HMI OP1 presses function key PHONEBOOK
When HMI OP1 selects call route selector: frqUser
Then HMI OP1 verify that call route selector shows FrqUser
When HMI OP1 writes in phonebook text box the address: 22222
When HMI OP1 initiates a call from the phonebook
Then HMI OP1 has the call queue item 2-OP1 in state out_ringing

Scenario: Caller initiates a call with Call Route Selector Gmail
When HMI OP1 presses function key PHONEBOOK
When HMI OP1 selects call route selector: gmail
Then HMI OP1 verify that call route selector shows Gmail
When HMI OP1 writes in phonebook text box the address: 2222
When HMI OP1 initiates a call from the phonebook
Then HMI OP1 has the call queue item 22-OP1 in state out_ringing

Scenario: Caller initiates a call with Call Route Selector Admin
When HMI OP1 presses function key PHONEBOOK
When HMI OP1 selects call route selector: admin
Then HMI OP1 verify that call route selector shows Admin
When HMI OP1 writes in phonebook text box the address: 222
When HMI OP1 initiates a call from the phonebook
Then HMI OP1 has the call queue item 222-OP1 in state out_ringing

Scenario: Caller initiates a call with Call Route Selector Super
When HMI OP1 presses function key PHONEBOOK
When HMI OP1 selects call route selector: super
Then HMI OP1 verify that call route selector shows Super
When HMI OP1 writes in phonebook text box the address: 22
When HMI OP1 initiates a call from the phonebook
Then HMI OP1 has the call queue item 2222-OP1 in state out_ringing

Scenario: Caller initiates a call with Call Route Selector Student
When HMI OP1 presses function key PHONEBOOK
When HMI OP1 selects call route selector: student
Then HMI OP1 verify that call route selector shows Student
When HMI OP1 writes in phonebook text box the address: 2
When HMI OP1 initiates a call from the phonebook
Then HMI OP1 has the call queue item 22222-OP1 in state out_ringing

Scenario: Caller clears last outgoing call
Then HMI OP1 terminates the call queue item 22222-OP1
Then HMI OP1 has in the call queue a number of 0 calls

