Narrative:
As a caller operator having an active mission
I want to change mission
So I can verify that I can access other missions

Scenario: Booking profiles
Given booked profiles:
| profile | group | host           | identifier |
| javafx  | hmi   | <<CLIENT1_IP>> | HMI OP1    |

Scenario: Verify operator mission
Then HMI OP1 has in the display status section mission the assigned mission MAN-NIGHT-TACT

Scenario: Change mission
		  @REQUIREMENTS: GID-3003102
		  @REQUIREMENTS: GID-3003103
		  @REQUIREMENTS: GID-4324230
		  @REQUIREMENTS: GID-4324231
When HMI OP1 presses function key MISSIONS
Then HMI OP1 has a list of 3 missions available
Then HMI OP1 has missions EAST-EXEC, MAN-NIGHT-TACT, WEST-EXEC available in the missions list
Then HMI OP1 changes current mission to mission WEST-EXEC
Then HMI OP1 activates mission
Then waiting for 5 seconds

Scenario: Verify operator mission
Then HMI OP1 has in the display status section mission the assigned mission WEST-EXEC

Scenario: Select mission and close pop-up with activating the mission
When HMI OP1 presses function key MISSIONS
Then HMI OP1 has a list of 3 missions available
Then HMI OP1 has missions EAST-EXEC, MAN-NIGHT-TACT, WEST-EXEC available in the missions list
Then HMI OP1 changes current mission to mission EAST-EXEC
Then HMI OP1 activates mission
Then waiting for 5 seconds

Scenario: Verify operator mission
Then HMI OP1 has in the display status section mission the assigned mission EAST-EXEC

Scenario: Change to previous mission
When HMI OP1 presses function key MISSIONS
Then HMI OP1 has a list of 3 missions available
Then HMI OP1 has missions EAST-EXEC, MAN-NIGHT-TACT, WEST-EXEC available in the missions list
Then HMI OP1 changes current mission to mission MAN-NIGHT-TACT
Then HMI OP1 activates mission
Then waiting for 5 seconds

Scenario: Verify operator mission
Then HMI OP1 has in the display status section mission the assigned mission MAN-NIGHT-TACT



