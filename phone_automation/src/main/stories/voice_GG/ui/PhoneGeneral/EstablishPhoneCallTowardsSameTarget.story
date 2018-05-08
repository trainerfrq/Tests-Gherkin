Narrative:
As a caller operator having a connected phone call with a callee operator
I want to initiate another phone call towards the same callee operator
So I can verify that the already existing call is reused and no other call is established

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
When HMI OP2 presses DA key OP1

Scenario: Verify call is connected
Then HMI OP1 has the call queue item OP2-OP1 in state connected
Then HMI OP2 has the call queue item OP1-OP2 in state connected

Scenario: Caller establishes another outgoing call towards the same target
		  @REQUIREMENTS:GID-3657854
When HMI OP1 presses DA key OP2(as OP3)

Scenario: Verify call is connected for caller and no other call is in queue
Then HMI OP1 has the call queue item OP2-OP1 in state connected
Then HMI OP1 has in the call queue a number of 1 calls

Scenario: Verify call is connected for callee and no other call is in queue
Then HMI OP2 has the call queue item OP1-OP2 in state connected
Then HMI OP2 has in the call queue a number of 1 calls

Scenario: Callee clears outgoing call
When HMI OP2 presses DA key OP1
