Narrative:
As a callee operator having a call held by the caller operator
I want to put the call on hold also on my side
So I can verify that call is put on hold on both sides, and that both me and the caller operator can retrieve the call from hold

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
Then HMI OP2 has the DA key OP1 in state inc_initiated
Then HMI OP2 has the call queue item OP1-OP2 in state inc_initiated

Scenario: Callee accepts incoming call
When HMI OP2 presses DA key OP1

Scenario: Verify call is connected
Then HMI OP1 has the call queue item OP2-OP1 in state connected
Then HMI OP2 has the call queue item OP1-OP2 in state connected

Scenario: Caller puts call on hold
		  @REQUIREMENTS:GID-2505734
		  @REQUIREMENTS:GID-2510074
When HMI OP1 puts on hold the active call

Scenario: Verify call state for both operators
Then HMI OP1 has the call queue item OP2-OP1 in state hold
Then HMI OP2 has the call queue item OP1-OP2 in state held

Scenario: Verify call queue section
		  @REQUIREMENTS:GID-3371934
Then HMI OP1 has the call queue item OP2-OP1 in the hold list with label OP2 Physical
Then HMI OP2 has the call queue item OP1-OP2 in the active list with label 111111

Scenario: Callee puts the call on hold
When HMI OP2 puts on hold the active call

Scenario: Verify call state for both operators
Then HMI OP1 has the call queue item OP2-OP1 in state hold
Then HMI OP2 has the call queue item OP1-OP2 in state hold

Scenario: Callee retrieves call from hold
		  @REQUIREMENTS:GID-2510075
Then HMI OP2 retrieves from hold the call queue item OP1-OP2

Scenario: Verify call state for both operators
Then HMI OP1 has the call queue item OP2-OP1 in state hold
Then HMI OP2 has the call queue item OP1-OP2 in state held

Scenario: Caller retrieves call from hold
		  @REQUIREMENTS:GID-2510075
Then HMI OP1 retrieves from hold the call queue item OP2-OP1

Scenario: Verify call is connected again
Then HMI OP1 has the call queue item OP2-OP1 in state connected
Then HMI OP2 has the call queue item OP1-OP2 in state connected

Scenario: Verify call queue section
		  @REQUIREMENTS:GID-3371935
Then HMI OP1 verifies that the call queue item OP2-OP1 was removed from the hold list
Then HMI OP1 has the call queue item OP2-OP1 in the active list with label OP2 Physical
Then HMI OP2 has the call queue item OP1-OP2 in the active list with label 111111

Scenario: Callee clears outgoing call
When HMI OP2 presses DA key OP1
