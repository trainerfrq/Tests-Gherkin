Scenario: OP1 switches to default mission if needed
Then HMI OP1 with layout <<LAYOUT_MISSION2>> will do a change mission if DISPLAY STATUS section mission has not the default mission MAN-NIGHT-TACT
Then wait for 5 seconds
Then HMI OP1 with layout <<LAYOUT_MISSION3>> will do a change mission if DISPLAY STATUS section mission has not the default mission MAN-NIGHT-TACT

Scenario: OP2 switches to default mission if needed
Then HMI OP2 with layout <<LAYOUT_MISSION1>> will do a change mission if DISPLAY STATUS section mission has not the default mission WEST-EXEC
Then wait for 5 seconds
Then HMI OP2 with layout <<LAYOUT_MISSION3>> will do a change mission if DISPLAY STATUS section mission has not the default mission WEST-EXEC
Then wait for 5 seconds
Then HMI OP2 with layout <<LAYOUT_MISSION4>> will do a change mission if DISPLAY STATUS section mission has not the default mission WEST-EXEC

Scenario: OP3 switches to default mission if needed
Then HMI OP3 with layout <<LAYOUT_MISSION2>> will do a change mission if DISPLAY STATUS section mission has not the default mission EAST-EXEC
Then wait for 5 seconds
Then HMI OP3 with layout <<LAYOUT_MISSION1>> will do a change mission if DISPLAY STATUS section mission has not the default mission EAST-EXEC
