Narrative:
As an operator having the maximum number of calls on hold reached
I want to put another call on hold
So I can verify that call is not put on hold

Scenario: Booking profiles
Given booked profiles:
| profile | group | host           | identifier |
| javafx  | hmi   | <<CLIENT1_IP>> | HMI OP1    |
| javafx  | hmi   | <<CLIENT2_IP>> | HMI OP2    |
| javafx  | hmi   | <<CLIENT3_IP>> | HMI OP3    |

Scenario: Define call queue items
Given the call queue items:
| key     | source                 | target                 | callType |
| OP1-OP2 | sip:111111@example.com | sip:222222@example.com | DA/IDA   |
| OP3-OP2 | sip:op3@example.com    | sip:222222@example.com | DA/IDA   |
| OP2-OP1 | sip:222222@example.com | sip:111111@example.com | DA/IDA   |
| OP2-OP3 | sip:222222@example.com | sip:op3@example.com    | DA/IDA   |

Scenario: Op1 establishes an outgoing call
When HMI OP1 presses DA key OP2(as OP1)
Then HMI OP1 has the DA key OP2(as OP1) in state out_ringing

Scenario: Op2 client receives the incoming call
Then HMI OP2 has the DA key OP1 in state ringing
Then HMI OP2 has the call queue item OP1-OP2 in state ringing

Scenario: Op2 accepts incoming call
When HMI OP2 presses DA key OP1

Scenario: Verify call is connected
Then HMI OP1 has the call queue item OP2-OP1 in state connected
Then HMI OP2 has the call queue item OP1-OP2 in state connected

Scenario: Op2 puts call on hold
When HMI OP2 puts on hold the active call

Scenario: Verify call is put on hold
Then HMI OP1 has the call queue item OP2-OP1 in state held
Then HMI OP2 has the call queue item OP1-OP2 in state hold

Scenario: Op3 establishes an outgoing call
When HMI OP3 presses DA key OP2(as OP3)
Then HMI OP3 has the DA key OP2(as OP3) in state out_ringing

Scenario: Op2 client receives the incoming call
Then HMI OP2 has the DA key OP3 in state ringing
Then HMI OP2 has the call queue item OP3-OP2 in state ringing

Scenario: Op2 accepts incoming call
When HMI OP2 presses DA key OP3

Scenario: Verify call is connected
Then HMI OP2 has the call queue item OP3-OP2 in state connected
Then HMI OP3 has the call queue item OP2-OP3 in state connected

Scenario: Op2 puts call on hold
When HMI OP2 puts on hold the active call

Scenario: Verify call is not put on hold
		  @REQUIREMENTS:GID-2604614
Then HMI OP2 has the call queue item OP3-OP2 in state connected
Then HMI OP3 has the call queue item OP2-OP3 in state connected

Scenario: Verify first call is still put on hold
Then HMI OP1 has the call queue item OP2-OP1 in state held
Then HMI OP2 has the call queue item OP1-OP2 in state hold

Scenario: Op2 clears active call
When HMI OP2 presses DA key OP3

Scenario: Op2 retrieves call from hold
Then HMI OP2 retrieves from hold the call queue item OP1-OP2

Scenario: Verify call is connected
Then HMI OP1 has the call queue item OP2-OP1 in state connected
Then HMI OP2 has the call queue item OP1-OP2 in state connected

Scenario: Op2 clears active call
When HMI OP2 presses DA key OP1
