Narrative:
As a called operator having an incoming phone call from a caller operator
I want to initiate a phone call towards the caller operator
So I can verify that the incoming phone call is accepted

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

Scenario: Caller establishes an outgoing call
When HMI OP1 presses DA key OP2(as OP1)
Then HMI OP1 has the DA key OP2(as OP1) in state out_ringing

Scenario: Callee client receives the incoming call
Then HMI OP2 has the DA key OP1 in state ringing
Then HMI OP2 has the call queue item OP1-OP2 in state ringing

Scenario: Caller establishes an outgoing call
		  @REQUIREMENTS:GID-2510577
When HMI OP2 presses DA key OP1

Scenario: Verify call is connected for OP1
Then HMI OP1 has the DA key OP2(as OP1) in state connected
Then HMI OP1 has the call queue item OP2-OP1 in state connected
Then HMI OP1 has in the call queue a number of 1 calls

Scenario: Verify call is connected for OP2
Then HMI OP2 has the DA key OP1 in state connected
Then HMI OP2 has the call queue item OP1-OP2 in state connected
Then HMI OP2 has in the call queue a number of 1 calls

Scenario: Callee clears outgoing call
When HMI OP2 presses DA key OP1
