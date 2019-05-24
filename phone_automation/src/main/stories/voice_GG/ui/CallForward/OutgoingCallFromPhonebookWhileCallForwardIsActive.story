Narrative:
As a caller operator having Call Forward active
I want to make an outgoing call from phone book
So I can verify that call can be done while Call Forward is active

Scenario: Booking profiles
Given booked profiles:
| profile | group | host           | identifier |
| javafx  | hmi   | <<CLIENT1_IP>> | HMI OP1    |
| javafx  | hmi   | <<CLIENT2_IP>> | HMI OP2    |

Scenario: Define call queue items
Given the call queue items:
| key     | source                 | target                 | callType |
| OP1-OP2 | sip:mission1@example.com | sip:222222@example.com | DA/IDA   |
| OP2-OP1 | sip:222222@example.com   |                        | DA/IDA   |

Scenario: Op1 activates Call Forward
When HMI OP1 presses function key CALLFORWARD
Then HMI OP1 has the function key CALLFORWARD in forwardOngoing state

Scenario: Op1 opens phonebook
When HMI OP1 presses function key PHONEBOOK
Then HMI OP1 verifies that phone book call button is disabled
Then HMI OP1 verifies that phone book forward button state is disabled

Scenario: Op1 selects an item from phonebook for the call forward action
When HMI OP1 selects phonebook entry number: 4
Then HMI OP1 verifies that phone book call button is enabled
Then HMI OP1 verifies that phone book forward button state is enabled
Then HMI OP1 has the function key CALLFORWARD in forwardOngoing state

Scenario: Op1 hits phonebook call button
When HMI OP1 activates call forward from phonebook

Scenario: Op1 activates call forward
		  @REQUIREMENTS:GID-2521111
Then HMI OP1 verifies that call queue info container is visible
Then HMI OP1 has in the call queue a number of 0 calls
Then HMI OP2 has in the call queue a number of 0 calls
Then HMI OP1 verifies that call queue info container contains Target: OP2 Physical
Then HMI OP1 has the function key CALLFORWARD in active state

Scenario: Op1 opens phonebook
When HMI OP1 presses function key PHONEBOOK
Then HMI OP1 verifies that phone book call button is disabled
Then HMI OP1 verifies that phone book forward button state is disabled

Scenario: Op1 selects an item from phonebook for the call forward action
When HMI OP1 selects phonebook entry number: 4
Then HMI OP1 verifies that phone book call button is enabled
Then HMI OP1 checks that phone book forward button is invisible
Then HMI OP1 has the function key CALLFORWARD in active state

Scenario: Op1 hits phonebook call button
When HMI OP1 initiates a call from the phonebook

Scenario: Call is initiated
Then HMI OP1 has the call queue item OP2-OP1 in the active list with name label OP2 Physical

Scenario: Caller clears outgoing call
Then HMI OP1 terminates the call queue item OP2-OP1

Scenario: Op1 still has Call Forward active
Then HMI OP1 has the function key CALLFORWARD in active state

Scenario: Op1 deactivates Call Forward
When HMI OP1 presses function key CALLFORWARD
Then HMI OP1 verifies that call queue info container is not visible


