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

Scenario: Caller selects call route selector
When HMI OP1 selects call route selector: Default

Scenario: Caller writes target address in text box
When HMI OP1 writes in phonebook text box the address: 222222

Scenario: Caller toggles call priority
When HMI OP1 toggles call priority

Scenario: Caller hits phonebook call button
		  @REQUIREMENTS:GID-2535727
		  @REQUIREMENTS:GID-2535740
		  @REQUIREMENTS:GID-2536683
		  @REQUIREMENTS:GID-2536682
When HMI OP1 initiates a call from the phonebook
Then waiting for 1 second

Scenario: Call is initiated
Then HMI OP1 has the call queue item OP2-OP1 in state out_ringing
Then HMI OP2 has the call queue item OP1-OP2 in state ringing

Scenario: Caller clears outgoing call
Then HMI OP1 terminates the call queue item OP2-OP1

Scenario: Call is terminated
Then HMI OP1 has in the call queue a number of 0 calls
Then HMI OP2 has in the call queue a number of 0 calls
