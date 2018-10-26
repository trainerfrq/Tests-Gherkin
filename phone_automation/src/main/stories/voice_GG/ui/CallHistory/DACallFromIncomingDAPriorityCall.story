Narrative:
As an operator
I want to initiate an outgoing DA call by clicking on a previous incoming DA priority call's history entry
So I can check that the call towards the corresponding entry is initiated as a routine call using the destination according to the selected call

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
When HMI OP1 initiates a priority call on DA key OP2(as OP1)
Then HMI OP1 has the DA key OP2(as OP1) in state out_ringing

Scenario: Callee client receives the incoming call
Then HMI OP2 has the DA key OP1 in state ringing
Then HMI OP2 has in the call queue the item OP1-OP2 with priority

Scenario: Callee client answers the incoming call
When HMI OP2 presses DA key OP1

Scenario: Verify call is connected for both operators
Then HMI OP1 has the call queue item OP2-OP1 in state connected
Then HMI OP2 has the call queue item OP1-OP2 in state connected
Then HMI OP2 verifies that call queue item bar signals call state priority

Scenario: Caller client clears the phone call
When HMI OP1 presses DA key OP2(as OP1)
Then HMI OP2 has in the call queue a number of 0 calls

Scenario: Callee opens call history
When HMI OP2 presses function key CALLHISTORY

Scenario: Callee selects first entry from history
When HMI OP2 selects call history list entry number: 0
Then HMI OP2 verifies that call history call button has label 111111

Scenario: Callee does call from call history
		  @REQUIREMENTS:GID-2535764
		  @REQUIREMENTS:GID-2536682
When HMI OP2 initiates a call from the call history
Then HMI OP2 has the DA key OP1 in state out_ringing

Scenario: Op1 receives the incoming call
Then HMI OP1 has the DA key OP2(as OP1) in state ringing

Scenario: Op1 answers the incoming call
When HMI OP1 presses DA key OP2(as OP1)

Scenario: Verify call is connected for both operators
		  @REQUIREMENTS:GID-2535771
Then HMI OP1 has the call queue item OP2-OP1 in state connected
Then HMI OP2 has the call queue item OP1-OP2 in state connected
Then HMI OP1 verifies that call queue item bar signals call state active

Scenario: Caller client clears the phone call
When HMI OP1 presses DA key OP2(as OP1)
Then HMI OP2 has in the call queue a number of 0 calls

Scenario: Call is terminated also for caller
Then HMI OP1 has in the call queue a number of 0 calls