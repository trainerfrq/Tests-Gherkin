Scenario: Change mission
When HMI OP1 with layout <<LAYOUT_MISSION2>> presses function key MISSIONS
Then HMI OP1 changes current mission to mission <<MISSION_1_NAME>>
Then HMI OP1 activates mission
Then waiting for 5 seconds

Scenario: Verify operator mission
Then HMI OP1 has in the DISPLAY STATUS section mission the assigned mission <<MISSION_1_NAME>>

Scenario: Change to mission
When HMI OP2 with layout <<LAYOUT_MISSION2>> presses function key MISSIONS
Then HMI OP2 changes current mission to mission <<MISSION_2_NAME>>
Then HMI OP2 activates mission
Then waiting for 5 seconds

Scenario: Verify operator mission
Then HMI OP2 has in the DISPLAY STATUS section mission the assigned mission <<MISSION_2_NAME>>
