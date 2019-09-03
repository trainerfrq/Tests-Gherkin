Narrative:
As a caller operator having an active mission
I want to change mission
So I can verify what roles are assign to the active mission

Scenario: Booking profiles
Given booked profiles:
| profile | group | host           | identifier |
| javafx  | hmi   | <<CLIENT1_IP>> | HMI OP1    |
| javafx  | hmi   | <<CLIENT2_IP>> | HMI OP2    |
| javafx  | hmi   | <<CLIENT3_IP>> | HMI OP3    |

Scenario: Verify operator mission
Then HMI OP1 has in the DISPLAY STATUS section mission the assigned mission MAN-NIGHT-TACT

Scenario: Verify current active mission has the expected roles
		  @REQUIREMENTS: GID-2397112
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key MISSIONS
Then HMI OP1 has a list of 3 missions available
Then HMI OP1 has missions EAST-EXEC, MAN-NIGHT-TACT, WEST-EXEC available in the missions list
Then HMI OP1 verifies that current active mission is mission MAN-NIGHT-TACT
Then HMI OP1 has roles <<ROLE_1_NAME>>, role1alias2, groupall, role1, role1alias1, group1 available in the roles list

Scenario: Change mission
Then HMI OP1 changes current mission to mission WEST-EXEC
Then HMI OP1 activates mission
Then waiting for 5 seconds

Scenario: Verify operator mission
Then HMI OP1 has in the DISPLAY STATUS section mission the assigned mission WEST-EXEC

Scenario: Verify current active mission has the expected roles
		  @REQUIREMENTS: GID-2397112
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key MISSIONS
Then HMI OP1 has a list of 3 missions available
Then HMI OP1 has missions EAST-EXEC, MAN-NIGHT-TACT, WEST-EXEC available in the missions list
Then HMI OP1 verifies that current active mission is mission WEST-EXEC
Then HMI OP1 has roles <<ROLE_2_NAME>>, role2alias2, groupall, role2, role2alias1, group1 available in the roles list

Scenario: Change mission
Then HMI OP1 changes current mission to mission EAST-EXEC
Then HMI OP1 activates mission
Then waiting for 5 seconds

Scenario: Verify operator mission
Then HMI OP1 has in the DISPLAY STATUS section mission the assigned mission EAST-EXEC

Scenario: Verify current active mission has the expected roles
		  @REQUIREMENTS: GID-2397112
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key MISSIONS
Then HMI OP1 has a list of 3 missions available
Then HMI OP1 has missions EAST-EXEC, MAN-NIGHT-TACT, WEST-EXEC available in the missions list
Then HMI OP1 verifies that current active mission is mission EAST-EXEC
Then HMI OP1 has roles <<ROLE_3_NAME>>, role1alias1, groupall, role1, role1alias2, group1 available in the roles list

Scenario: Change mission
Then HMI OP1 changes current mission to mission MAN-NIGHT-TACT
Then HMI OP1 activates mission
Then waiting for 5 seconds

Scenario: Verify operator mission
Then HMI OP1 has in the DISPLAY STATUS section mission the assigned mission MAN-NIGHT-TACT



