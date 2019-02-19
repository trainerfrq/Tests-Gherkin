Narrative:
As an operator
I want to change mission
So I can verify that the state of the Loudspeaker doesn't change

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

Scenario: Op1 verifies Loudspeaker state
Then HMI OP1 has the function key LOUDSPEAKER label GG LSP disabled

Scenario: Caller establishes an outgoing call
When HMI OP1 presses DA key OP2(as OP1)
Then waiting for 3 seconds
Then HMI OP1 has the DA key OP2(as OP1) in state out_ringing

Scenario: Callee client receives the incoming call
Then HMI OP2 has the DA key OP1 in state inc_initiated

Scenario: Callee client answers the incoming call
Then HMI OP2 accepts the call queue item OP1-OP2
Then HMI OP1 has the call queue item OP2-OP1 in state connected
Then HMI OP2 has the call queue item OP1-OP2 in state connected

Scenario: Op1 activates loudspeaker
		  @REQUIREMENTS:GID-3005515
When HMI OP1 presses function key LOUDSPEAKER
Then HMI OP1 has the function key LOUDSPEAKER label GG LSP enabled

Scenario: Op1 changes mission
When HMI OP1 presses function key MISSIONS
Then HMI OP1 changes current mission to mission WEST-EXEC
Then HMI OP1 activates mission
Then waiting for 5 seconds

Scenario: Op1 verifies if Loudspeaker state is unmodified
Then HMI OP1 has the function key LOUDSPEAKER label GG LSP enabled

Scenario: Verify active call is still connected
Then HMI OP1 has the call queue item OP2-OP1 in state connected
Then HMI OP2 has the call queue item OP1-OP2 in state connected

Scenario: Op1 deactivates loudspeaker
When HMI OP1 presses function key LOUDSPEAKER
Then HMI OP1 has the function key LOUDSPEAKER label GG LSP disabled

Scenario: Op1 changes to initial mission
When HMI OP1 presses function key MISSIONS
Then HMI OP1 changes current mission to mission MAN-NIGHT-TACT
Then HMI OP1 activates mission
Then waiting for 5 seconds

Scenario: Clear call
Then HMI OP1 terminates the call queue item OP2-OP1
Then HMI OP2 has in the call queue a number of 0 calls
Then HMI OP1 has in the call queue a number of 0 calls

Scenario: Op1 verifies if Loudspeaker state is unmodified
Then HMI OP1 has the function key LOUDSPEAKER label GG LSP disabled