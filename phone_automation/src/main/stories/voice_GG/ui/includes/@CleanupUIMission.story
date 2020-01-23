Scenario: OP1 switches to default mission if needed
Then HMI OP1 with layout <<LAYOUT_MISSION2>> will do a change mission if DISPLAY STATUS section mission has not the default mission <<MISSION_1_NAME>>
Then wait for 5 seconds
Then HMI OP1 with layout <<LAYOUT_MISSION3>> will do a change mission if DISPLAY STATUS section mission has not the default mission <<MISSION_1_NAME>>
Then wait for 5 seconds
Then HMI OP1 with layout <<LAYOUT_MISSION4>> will do a change mission if DISPLAY STATUS section mission has not the default mission <<MISSION_1_NAME>>
Then wait for 5 seconds
Then HMI OP1 with layout <<COMMON_LAYOUT>> will do a change mission if DISPLAY STATUS section mission has not the default mission <<MISSION_1_NAME>>

Scenario: OP2 switches to default mission if needed
Then HMI OP2 with layout <<LAYOUT_MISSION1>> will do a change mission if DISPLAY STATUS section mission has not the default mission <<MISSION_2_NAME>>
Then wait for 5 seconds
Then HMI OP2 with layout <<LAYOUT_MISSION3>> will do a change mission if DISPLAY STATUS section mission has not the default mission <<MISSION_2_NAME>>
Then wait for 5 seconds
Then HMI OP2 with layout <<LAYOUT_MISSION4>> will do a change mission if DISPLAY STATUS section mission has not the default mission <<MISSION_2_NAME>>
Then wait for 5 seconds
Then HMI OP2 with layout <<COMMON_LAYOUT>> will do a change mission if DISPLAY STATUS section mission has not the default mission <<MISSION_2_NAME>>

Scenario: OP3 switches to default mission if needed
Then HMI OP3 with layout <<LAYOUT_MISSION2>> will do a change mission if DISPLAY STATUS section mission has not the default mission <<MISSION_3_NAME>>
Then wait for 5 seconds
Then HMI OP3 with layout <<LAYOUT_MISSION1>> will do a change mission if DISPLAY STATUS section mission has not the default mission <<MISSION_3_NAME>>
Then wait for 5 seconds
Then HMI OP3 with layout <<LAYOUT_MISSION4>> will do a change mission if DISPLAY STATUS section mission has not the default mission <<MISSION_3_NAME>>
Then wait for 5 seconds
Then HMI OP3 with layout <<COMMON_LAYOUT>> will do a change mission if DISPLAY STATUS section mission has not the default mission <<MISSION_3_NAME>>
