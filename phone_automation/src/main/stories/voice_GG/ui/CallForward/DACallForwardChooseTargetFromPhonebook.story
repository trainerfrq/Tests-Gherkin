Narrative:
As a caller operator having to leave temporarily my Operator Position
I want to activate CallForward and choose target from phone book
So I can verify that all DA calls are forwarded to the selected target Operator Position

Scenario: Booking profiles
Given booked profiles:
| profile | group | host           | identifier |
| javafx  | hmi   | <<CLIENT1_IP>> | HMI OP1    |
| javafx  | hmi   | <<CLIENT2_IP>> | HMI OP2    |
| javafx  | hmi   | <<CLIENT3_IP>> | HMI OP3    |

Scenario: Define call queue items
Given the call queue items:
| key     | source                 | target                 | callType |
| OP3-OP2 | sip:op3@example.com    | sip:222222@example.com | DA/IDA   |
| OP2-OP3 | sip:222222@example.com | sip:op3@example.com    | DA/IDA   |
| OP1-OP3 | sip:111111@example.com | sip:op3@example.com    | DA/IDA   |
| OP3-OP1 | sip:op3@example.com    | sip:111111@example.com | DA/IDA   |

Scenario: Op1 activates Call Forward
When HMI OP1 presses function key CALLFORWARD
Then HMI OP1 has the function key CALLFORWARD in forwardOngoing state
Then HMI OP1 verifies that call queue info container is not visible

Scenario: Op1 opens phonebook
When HMI OP1 presses function key PHONEBOOK
Then HMI OP1 verifies that phone book call button is disabled
Then HMI OP1 verifies that phone book forward button state is disabled

Scenario: Op1 selects an item from phonebook for the call forward action
		  @REQUIREMENTS:GID-2521111
When HMI OP1 selects phonebook entry number: 4
Then HMI OP1 verifies that phone book call button is enabled
Then HMI OP1 verifies that phone book forward button state is enabled
Then HMI OP1 has the function key CALLFORWARD in forwardOngoing state

Scenario: Op1 activates call forward
When HMI OP1 activates call forward from phonebook
Then HMI OP1 has the function key CALLFORWARD in forwardActive state
Then HMI OP1 verifies that call queue info container is visible
Then HMI OP1 verifies that call queue info container contains Target: OP2 Physical
Then HMI OP1 has in the call queue a number of 0 calls
Then HMI OP2 has in the call queue a number of 0 calls

Scenario: Op3 establishes an outgoing call
When HMI OP3 presses DA key OP1(as OP3)
Then HMI OP3 has the DA key OP1(as OP3) in state out_ringing

Scenario: Call is automatically forwarded to Op2
		  @REQUIREMENTS:GID-2521112
Then HMI OP1 has in the call queue a number of 0 calls
Then HMI OP2 has the DA key OP3 in state inc_initiated

Scenario: Op2 client answers the incoming call
When HMI OP2 presses DA key OP3

Scenario: Verify call is connected for both operators
Then HMI OP2 has the call queue item OP3-OP2 in state connected
Then HMI OP3 has the call queue item OP1-OP3 in state connected
Then HMI OP1 has in the call queue a number of 0 calls
Then HMI OP1 has the function key CALLFORWARD in forwardActive state

Scenario: Op3 client clears the phone call
When HMI OP3 presses DA key OP1(as OP3)
Then HMI OP3 has in the call queue a number of 0 calls

Scenario: Call is terminated also for Op2
Then HMI OP2 has in the call queue a number of 0 calls

Scenario: Op1 still has Call Forward active
Then HMI OP1 has the function key CALLFORWARD in forwardActive state

Scenario: Op1 deactivates Call Forward
When HMI OP1 presses function key CALLFORWARD
Then HMI OP1 verifies that call queue info container is not visible



