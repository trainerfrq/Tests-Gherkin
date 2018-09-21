Narrative:
As a caller operator
I want to establish an outgoing call
So I can verify that the caller identity for the incoming call is displayed.

Scenario: Booking profiles
Given booked profiles:
| profile | group | host           | identifier |
| javafx  | hmi   | <<CLIENT1_IP>> | HMI OP1    |
| javafx  | hmi   | <<CLIENT2_IP>> | HMI OP2    |

Scenario: Define call queue items
Given the call queue items:
| key     | source                 | target                 | callType |
| OP2-OP1 | sip:222222@example.com | sip:111111@example.com | IA       |

Scenario: Caller establishes an outgoing IA call
When HMI OP2 presses IA key IA - OP1

Scenario: Callee client receives the incoming call with the identity of the caller
Then HMI OP1 has the call queue item OP2-OP1 in the active list with label OP2 Physical

Scenario: Caller client clears the phone call
When HMI OP2 presses IA key IA - OP1

Scenario: Call is terminated for both
Then HMI OP1 has in the call queue a number of 0 calls
Then HMI OP2 has in the call queue a number of 0 calls
