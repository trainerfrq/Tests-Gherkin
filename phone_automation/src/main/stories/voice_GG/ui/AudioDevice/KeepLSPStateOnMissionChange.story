Narrative:
As an operator
I want to change mission
So I can verify that the state of the Loudspeaker doesn't change

Scenario: Booking profiles
Given booked profiles:
| profile | group | host           | identifier |
| javafx  | hmi   | <<CLIENT1_IP>> | HMI OP1    |
| javafx  | hmi   | <<CLIENT2_IP>> | HMI OP2    |

Scenario: Op1 verifies Loudspeaker state
Then HMI OP1 has the function key LOUDSPEAKER label GG LSP disabled

Scenario: Op1 activates loudspeaker
		  @REQUIREMENTS:GID-3005515
		  @REQUIREMENTS:GID-4231216
When HMI OP1 presses function key LOUDSPEAKER
Then HMI OP1 has the function key LOUDSPEAKER label GG LSP enabled

Scenario: Op1 changes mission
When HMI OP1 presses function key MISSIONS
Then HMI OP1 changes current mission to mission WEST-EXEC
Then HMI OP1 activates mission
Then waiting for 5 seconds

Scenario: Op1 verifies if Loudspeaker state is unmodified
Then HMI OP1 has the function key LOUDSPEAKER label GG LSP enabled

Scenario: Op1 deactivates loudspeaker
When HMI OP1 presses function key LOUDSPEAKER
Then HMI OP1 has the function key LOUDSPEAKER label GG LSP disabled
Then HMI OP2 has the function key LOUDSPEAKER label GG LSP disabled

Scenario: Op1 changes to initial mission
When HMI OP1 presses function key MISSIONS
Then HMI OP1 changes current mission to mission MAN-NIGHT-TACT
Then HMI OP1 activates mission
Then waiting for 5 seconds

Scenario: Op1 verifies if Loudspeaker state is unmodified
Then HMI OP1 has the function key LOUDSPEAKER label GG LSP disabled

Scenario: Op2 verifies Loudspeaker state
Then HMI OP1 has the function key LOUDSPEAKER label GG LSP disabled

Scenario: Op2 changes mission
When HMI OP2 presses function key MISSIONS
Then HMI OP2 changes current mission to mission MAN-NIGHT-TACT
Then HMI OP2 activates mission
Then waiting for 5 seconds

Scenario: Op2 verifies if Loudspeaker state is unmodified
Then HMI OP2 has the function key LOUDSPEAKER label GG LSP disabled

Scenario: Op2 changes to initial mission
When HMI OP2 presses function key MISSIONS
Then HMI OP2 changes current mission to mission WEST-EXEC
Then HMI OP2 activates mission
Then waiting for 5 seconds

Scenario: Op2 verifies if Loudspeaker state is unmodified
Then HMI OP2 has the function key LOUDSPEAKER label GG LSP disabled
