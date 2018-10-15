Narrative:
As an operator
I want to establish 101 calls
So I can check that the call history list supports up to 100 calls

Scenario: Booking profiles
Given booked profiles:
| profile | group | host           | identifier |
| javafx  | hmi   | <<CLIENT1_IP>> | HMI OP1    |
| javafx  | hmi   | <<CLIENT2_IP>> | HMI OP2    |

Scenario: Define call queue items
Given the call queue items:
| key     | source                 | target                 | callType |
| OP1-OP2 | sip:111111@example.com | sip:222222@example.com | DA/IDA   |
| OP2-OP1 | sip:222222@example.com | sip:111111@example.com | DA/IDA   |

Scenario: Caller clears call history list
When HMI OP2 presses function key CALLHISTORY
Then HMI OP2 clears Call History list
Then HMI OP2 verifies that call history list contains 0 entries
Then HMI OP2 closes Call History popup window

Scenario: Caller establishes 100 outgoing calls towards same target
When HMI OP2 presses for 200 times the DA key OP1

Scenario: Verify call is terminated for both operators
Then HMI OP1 has in the call queue a number of 0 calls
Then HMI OP2 has in the call queue a number of 0 calls

Scenario: Caller opens call history
When HMI OP2 presses function key CALLHISTORY

Scenario: Caller verifies the call history list
Then HMI OP2 verifies that call history list contains 100 entries
When HMI OP2 selects call history list entry number: 0
Then HMI OP2 verifies that call history call button has label OP1
When HMI OP2 selects call history list entry number: 1
Then HMI OP2 verifies that call history call button has label OP1
When HMI OP2 selects call history list entry number: 2
Then HMI OP2 verifies that call history call button has label OP1

Scenario: Caller closes call history
Then HMI OP2 closes Call History popup window

Scenario: Caller establishes the 101st call
When HMI OP2 presses DA key OP1

Scenario: Caller client clears the phone call
When HMI OP2 presses DA key OP1
Then HMI OP2 has in the call queue a number of 0 calls

Scenario: Call is terminated also for caller
Then HMI OP1 has in the call queue a number of 0 calls

Scenario: Caller opens call history
When HMI OP2 presses function key CALLHISTORY

Scenario: Caller verifies that the call history list still has 100 entries
Then HMI OP2 verifies that call history list contains 100 entries

Scenario: Caller clears call history list
Then HMI OP2 clears Call History list
Then HMI OP2 verifies that call history list contains 0 entries
Then HMI OP2 closes Call History popup window



