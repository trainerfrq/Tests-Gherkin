Narrative:
As a caller operator having a call on hold with a callee operator
I want to initiate another phone call towards the same callee operator
So I can verify that the already existing call is retrieved from hold and no other call is established

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
| OP2-OP3 | sip:222222@example.com | sip:op3@example.com    | DA/IDA   |

Scenario: Caller establishes an outgoing call
When HMI OP1 presses DA key OP2(as OP1)
Then HMI OP1 has the DA key OP2(as OP1) in state out_ringing

Scenario: Callee client receives the incoming call
Then HMI OP2 has the DA key OP1 in state inc_initiated
Then HMI OP2 has the call queue item OP1-OP2 in state inc_initiated

Scenario: Callee accepts incoming call
When HMI OP2 presses DA key OP1

Scenario: Verify call is connected
Then HMI OP1 has the call queue item OP2-OP1 in state connected
Then HMI OP2 has the call queue item OP1-OP2 in state connected

Scenario: Caller puts call on hold
When HMI OP1 puts on hold the active call
Then HMI OP1 has the call queue item OP2-OP1 in state hold

Scenario: Caller establishes another outgoing call towards the same target
		  @REQUIREMENTS:GID-3657854
		  @REQUIREMENTS:GID-2510075
When HMI OP1 presses DA key OP2(as OP3)

Scenario: Verify call is connected again
Then HMI OP1 has the call queue item OP2-OP3 in state connected
Then HMI OP2 has the call queue item OP1-OP2 in state connected

Scenario: Callee clears outgoing call
When HMI OP2 presses DA key OP1
