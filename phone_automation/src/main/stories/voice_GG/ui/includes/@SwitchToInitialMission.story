Scenario: Change mission
Then HMI OP1 with layout <<LAYOUT_MISSION2>> will do a change mission if DISPLAY STATUS 2 section mission has not the default mission <<MISSION_1_NAME>>
Then wait for 5 seconds

Scenario: Verify operator mission
Then HMI OP1 has in the DISPLAY STATUS section mission the assigned mission <<MISSION_1_NAME>>

Scenario: Change to mission
Then HMI OP2 with layout <<LAYOUT_MISSION1>> will do a change mission if DISPLAY STATUS 1 section mission has not the default mission <<MISSION_2_NAME>>
Then wait for 5 seconds

Scenario: Verify operator mission
Then HMI OP2 has in the DISPLAY STATUS section mission the assigned mission <<MISSION_2_NAME>>
