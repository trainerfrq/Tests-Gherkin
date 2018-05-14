Narrative:
As an operator
I want to initiate an outgoing DA priority call towards another operator
So I can check that all the call attributes are set for the call

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

Scenario: Caller establishes an outgoing priority call
		  @REQUIREMENTS:GID-2535689
		  @REQUIREMENTS:GID-2535706
		  @REQUIREMENTS:GID-2932449
		  @REQUIREMENTS:GID-2682478
When HMI OP1 initiates a priority call on DA key OP2(as OP1)
Then HMI OP1 has the DA key OP2(as OP1) in state out_ringing

Scenario: Callee client receives the incoming priority call
		  @REQUIREMENTS:GID-2535717
		  @REQUIREMENTS:GID-2512204
Then HMI OP2 has the DA key OP1 in state ringing
Then HMI OP2 has in the call queue the item OP1-OP2 with priority

Scenario: Callee client answers the incoming priority call
		  @REQUIREMENTS:GID-2510577
When HMI OP2 presses DA key OP1

Scenario: Verify call is connected for both operators
Then HMI OP1 has the call queue item OP2-OP1 in state connected
Then HMI OP2 has the call queue item OP1-OP2 in state connected

Scenario: Callee terminates call
		  @REQUIREMENTS:GID-2510109
When HMI OP2 presses DA key OP1
Then HMI OP2 has in the call queue a number of 0 calls

Scenario: Call is terminated also for caller
Then HMI OP1 has in the call queue a number of 0 calls
