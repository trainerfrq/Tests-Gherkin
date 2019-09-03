Narrative:
As a caller operator having an active mission
I want to change mission
So I can verify that for active mission the SIP address of Master role is used

Scenario: Booking profiles
Given booked profiles:
| profile | group | host           | identifier |
| javafx  | hmi   | <<CLIENT1_IP>> | HMI OP1    |
| javafx  | hmi   | <<CLIENT2_IP>> | HMI OP2    |
| javafx  | hmi   | <<CLIENT3_IP>> | HMI OP3    |

Scenario: Define call queue items
Given the call queue items:
| key     | source        | target        | callType |
| OP1-OP2 | <<ROLE1_URI>> | <<ROLE2_URI>> | DA/IDA   |
| OP2-OP1 | <<ROLE2_URI>> |               | DA/IDA   |
| OP1-OP3 | <<ROLE2_URI>> | <<ROLE3_URI>> | DA/IDA   |
| OP3-OP1 | <<ROLE3_URI>> |               | DA/IDA   |
| OP2-OP3 | <<ROLE3_URI>> | <<ROLE2_URI>> | DA/IDA   |
| OP3-OP2 | <<ROLE2_URI>> |               | DA/IDA   |

Scenario: Verify current active mission has the expected roles
		  @REQUIREMENTS: GID-2890901
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key MISSIONS
Then HMI OP1 verifies that current active mission is mission MAN-NIGHT-TACT
Then HMI OP1 has roles <<ROLE_1_NAME>>, role1alias2, groupall, role1, role1alias1, group1 available in the roles list

Scenario: Close mission windows
Then HMI OP1 closes mission popup

Scenario: Call mission WEST-EXEC using SIP master role
When HMI OP1 presses DA key <<ROLE_2_NAME>>
Then HMI OP1 has the DA key <<ROLE_2_NAME>> in state out_ringing
Then HMI OP1 has the call queue item OP2-OP1 in state out_ringing

Scenario: Position with mission WEST-EXEC receives call
		  @REQUIREMENTS: GID-2890901
Then HMI OP2 has the call queue item OP1-OP2 in state inc_initiated
Then HMI OP2 has the call queue item OP1-OP2 in the priority list with name label <<ROLE_1_NAME>>

Scenario: End call
When HMI OP1 presses DA key <<ROLE_2_NAME>>

Scenario: Call is terminated
Then HMI OP1 has in the call queue a number of 0 calls
Then HMI OP2 has in the call queue a number of 0 calls

Scenario: Change mission
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key MISSIONS
Then HMI OP1 changes current mission to mission WEST-EXEC
Then HMI OP1 activates mission
Then waiting for 5 seconds

Scenario: Verify current active mission has the expected roles
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key MISSIONS
Then HMI OP1 verifies that current active mission is mission WEST-EXEC
Then HMI OP1 has roles <<ROLE_2_NAME>>, role2alias2, groupall, role2, role2alias1, group1 available in the roles list

Scenario: Close mission windows
Then HMI OP1 closes mission popup

Scenario: Call mission EAST-EXEC using SIP master role
When HMI OP1 presses DA key <<ROLE_3_NAME>>
Then HMI OP1 has the DA key <<ROLE_3_NAME>> in state out_ringing
Then HMI OP1 has the call queue item OP3-OP1 in state out_ringing

Scenario: Position with mission WEST-EXEC receives call
		  @REQUIREMENTS: GID-2890901
Then HMI OP3 has the call queue item OP1-OP3 in state inc_initiated
Then HMI OP3 has the call queue item OP1-OP3 in the priority list with name label <<ROLE_2_NAME>>

Scenario: End call
When HMI OP1 presses DA key <<ROLE_3_NAME>>

Scenario: Call is terminated
Then HMI OP1 has in the call queue a number of 0 calls
Then HMI OP3 has in the call queue a number of 0 calls

Scenario: Change mission
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key MISSIONS
Then HMI OP1 changes current mission to mission EAST-EXEC
Then HMI OP1 activates mission
Then waiting for 5 seconds

Scenario: Verify current active mission has the expected roles
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key MISSIONS
Then HMI OP1 verifies that current active mission is mission EAST-EXEC
Then HMI OP1 has roles <<ROLE_3_NAME>>, role1alias1, groupall, role1, role1alias2, group1 available in the roles list

Scenario: Close mission windows
Then HMI OP1 closes mission popup

Scenario: Call mission WEST-EXEC using SIP master role
When HMI OP1 presses DA key OP3 - <<ROLE_2_NAME>>
Then HMI OP1 has the DA key OP3 - <<ROLE_2_NAME>> in state out_ringing
Then HMI OP1 has the call queue item OP3-OP2 in state out_ringing

Scenario: Position with mission WEST-EXEC receives call
		  @REQUIREMENTS: GID-2890901
Then HMI OP2 has the call queue item OP2-OP3 in state inc_initiated
Then HMI OP2 has the call queue item OP2-OP3 in the priority list with name label <<ROLE_3_NAME>>

Scenario: End call
When HMI OP1 presses DA key OP3 - <<ROLE_2_NAME>>

Scenario: Call is terminated
Then HMI OP1 has in the call queue a number of 0 calls
Then HMI OP2 has in the call queue a number of 0 calls

Scenario: Change mission
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key MISSIONS
Then HMI OP1 changes current mission to mission MAN-NIGHT-TACT
Then HMI OP1 activates mission
Then waiting for 5 seconds

Scenario: Verify operator mission
Then HMI OP1 has in the DISPLAY STATUS section mission the assigned mission MAN-NIGHT-TACT



