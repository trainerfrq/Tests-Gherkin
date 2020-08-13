Scenario: Define the DA keys
Given the DA keys:
| source  | target                     | id                                   |
| HMI OP1 | OP1                        | <<PhyOpPos1_CWP1>>                   |
| HMI OP1 | OP2                        | <<PhyOpPos1_CWP2>>                   |
| HMI OP1 | OP3                        | <<PhyOpPos1_CWP3>>                   |
| HMI OP1 | IA - OP1                   |                                      |
| HMI OP1 | IA - OP2                   | <<IA_PhyOpPos1_CWP2>>                |
| HMI OP1 | IA - OP3                   | <<IA_PhyOpPos1_CWP3>>                |
| HMI OP1 | ROLE2                      | <<ROLE1_ROLE2>>                      |
| HMI OP1 | ROLE1                      | <<PhyOpPos1_ROLE1>>                  |
| HMI OP1 | ROLE2-ALIAS                | <<ROLE1_ROLE2ALIAS1>>                |
| HMI OP1 | Madoline                   | <<IA_PhyOpPos1_Madoline>>            |
| HMI OP1 | OP2(as Mission3)           | <<MISSION3_CWP2>>                    |
| HMI OP1 | OP3(as Mission2)           | <<PhyOpPos2_CWP3>>                   |
| HMI OP1 | OP2(as ActiveMission)      | <<ACTIVE1_CWP2>>                     |
| HMI OP1 | OP1(as Mission3)           | <<MISSION3_CWP1>>                    |
| HMI OP1 | IA - <<ROLE_2_NAME>>       | <<IA_ACTIVE_MISSION2>>               |
| HMI OP1 | <<ROLE_2_NAME>>            | <<ACTIVE1_MISSION2>>                 |
| HMI OP1 | <<ROLE_3_NAME>>            | <<ACTIVE2_MISSION3>>                 |
| HMI OP1 | OP3 - <<ROLE_2_NAME>>      | <<ACTIVE3_MISSION2>>                 |
| HMI OP1 | Test_Mayo                  | <<PhyOpPos1_Test_Mayo>>              |
| HMI OP1 | Test_Alejandra             | <<PhyOpPos1_Test_Alejandra>>         |
| HMI OP1 | Test_Hurst                 | <<PhyOpPos1_Test_Hurst>>             |
| HMI OP1 | Test_Ivy                   | <<PhyOpPos1_Test_Ivy>>               |
| HMI OP1 | Test_Kristi                | <<PhyOpPos1_Test_Kristi>>            |
| HMI OP1 | OP3(as Mission4)           | <<PhyOpPos1(MISSION4)_CWP3>>         |
| HMI OP1 | LegacyPhone                | <<Active1_LegacyPhone>>              |
| HMI OP1 | GND(as TWR)                | <<ACTIVE1_GND>>                      |
| HMI OP1 | OP2(as GND)                | <<PhyOpPos1(GND)_CWP2>>              |
| HMI OP1 | OP3(as GND)                | <<PhyOpPos1(GND)_CWP3>>              |
| HMI OP1 | <<ROLE_1_NAME>>            | <<ACTIVE2_MISSION1>>                 |
| HMI OP1 | IA - OP2(as GND)           | <<IA_PhysOpPos1(GND)_CWP2>>          |
| HMI OP2 | OP1                        | <<PhyOpPos2_CWP1>>                   |
| HMI OP2 | OP2                        |                                      |
| HMI OP2 | OP3                        | <<PhyOpPos2_CWP3>>                   |
| HMI OP2 | IA - OP1                   | <<IA_PhyOpPos2_CWP1>>                |
| HMI OP2 | IA - OP2                   | <<IA_PhyOpPos2_CWP2>>                |
| HMI OP2 | IA - OP3                   | <<IA_PhyOpPos2_CWP3>>                |
| HMI OP2 | ROLE1                      | <<PhyOpPos2_ROLE1>>                  |
| HMI OP2 | ROLE1-GROUPCALL            | <<PhyOpPos2_ROLE1-GROUPCALL>>        |
| HMI OP2 | ROLE1(as ROLE2)            | <<ROLE2_ROLE1>>                      |
| HMI OP2 | ROLE1-ALIAS                | <<PhyOpPos2_ROLE1ALIAS1>>            |
| HMI OP2 | ROLE1-ALIAS(as ROLE2)      | <<ROLE2_ROLE1ALIAS1>>                |
| HMI OP2 | IA - ROLE1                 | <<IA_PhyOpPos2_ROLE1>>               |
| HMI OP2 | OP1(as Mission2)           | <<ACTIVE2_CWP1>>                     |
| HMI OP2 | IA - <<ROLE_1_NAME>>       | <<IA_ACTIVE2_MISSION1>>              |
| HMI OP2 | <<ROLE_3_NAME>>            | <<ACTIVE2_MISSION3>>                 |
| HMI OP2 | <<ROLE_1_NAME>>            | <<ACTIVE2_MISSION1>>                 |
| HMI OP2 | <<ROLE_2_NAME>>            | <<ACTIVE1_MISSION2>>                 |
| HMI OP2 | OP1(as Mission3)           | <<PhyOpPos3_CWP1>>                   |
| HMI OP2 | OP3(as Mission1)           | <<PhyOpPos1_CWP3>>                   |
| HMI OP2 | RoleEmergency(as Mission4) | <<PhyOpPos2_RoleEmergency_MISSION4>> |
| HMI OP2 | RoleEmergency              | <<PhyOpPos2_RoleEmergency>>          |
| HMI OP2 | TWR                        | <<ACTIVE2_TWR>>                      |
| HMI OP2 | GND                        | <<ACTIVE2_GND>>                      |
| HMI OP2 | APP                        | <<ACTIVE2_APP>>                      |
| HMI OP2 | SUP-TWR                    | <<ACTIVE2_SUP-TWR>>                  |
| HMI OP2 | TWR(as GND)                | <<ACTIVE2(GND)_TWR>>                 |
| HMI OP2 | APP(as GND)                | <<ACTIVE2(GND)_APP>>                 |
| HMI OP2 | SUP-TWR(as GND)            | <<ACTIVE2(GND)_SUP-TWR>>             |
| HMI OP3 | OP1                        | <<PhyOpPos3_CWP1>>                   |
| HMI OP3 | OP2                        | <<PhyOpPos3_CWP2>>                   |
| HMI OP3 | ROLE1                      | <<PhyOpPos3_ROLE1>>                  |
| HMI OP3 | <<ROLE_2_NAME>>            | <<ACTIVE3_MISSION2>>                 |
| HMI OP3 | IA - OP1                   | <<IA_PhyOpPos3_CWP1>>                |
| HMI OP3 | IA - OP2                   | <<IA_PhyOpPos3_CWP2>>                |
| HMI OP3 | <<ROLE_1_NAME>>            | <<ACTIVE3_MISSION1>>                 |
| HMI OP3 | OP1-urgent                 | <<PhyOpPos3_CWP1_urgent>>            |
| HMI OP3 | TWR                        | <<ACTIVE3_TWR>>                      |
| HMI OP3 | IA - TWR                   | <<IA_ACTIVE3_TWR>>                   |
| HMI OP3 | OP1(as Mission2)           | <<ACTIVE2_CWP1>>                     |
| HMI OP3 | GND(as SUP-TWR)            | <<ACTIVE3_GND>>                      |

Scenario: Define grid widget keys
Given the grid widget keys:
| layout              | id                         |
| <<LAYOUT_MISSION1>> | <<GRID_ID_MISSION1>>       |
| <<LAYOUT_MISSION2>> | <<GRID_ID_MISSION2>>       |
| <<LAYOUT_MISSION3>> | <<GRID_ID_MISSION3>>       |
| <<LAYOUT_MISSION4>> | <<GRID_ID_MISSION4>>       |
| <<LAYOUT_TWR>>      | <<GRID_ID_TWR_LAYOUT>>     |
| <<LAYOUT_GND>>      | <<GRID_ID_GND_LAYOUT>>     |
| <<LAYOUT_APP>>      | <<GRID_ID_APP_LAYOUT>>     |
| <<LAYOUT_SUP-TWR>>  | <<GRID_ID_SUP-TWR_LAYOUT>> |

Scenario: Define function keys
Given the function keys:
| layout              | key         | id                          |
| <<LAYOUT_MISSION1>> | PHONEBOOK   | <<PHONEBOOK_ID_MISSION1>>   |
| <<LAYOUT_MISSION1>> | CALLHISTORY | <<CALLHISTORY_ID_MISSION1>> |
| <<LAYOUT_MISSION1>> | MISSIONS    | <<MISSIONS_ID_MISSION1>>    |
| <<LAYOUT_MISSION1>> | CALLFORWARD | <<CALLFORWARD_ID_MISSION1>> |
| <<LAYOUT_MISSION1>> | LOUDSPEAKER | <<LOUDSPEAKER_ID_MISSION1>> |
| <<LAYOUT_MISSION1>> | SETTINGS    | <<SETTINGS_ID_MISSION1>>    |
| <<LAYOUT_MISSION1>> | MONITORING  | <<MONITORING_ID_MISSION1>>  |
| <<LAYOUT_MISSION1>> | EDIT        | <<EDIT_ID_MISSION1>>        |
| <<LAYOUT_MISSION2>> | PHONEBOOK   | <<PHONEBOOK_ID_MISSION2>>   |
| <<LAYOUT_MISSION2>> | CALLHISTORY | <<CALLHISTORY_ID_MISSION2>> |
| <<LAYOUT_MISSION2>> | MISSIONS    | <<MISSIONS_ID_MISSION2>>    |
| <<LAYOUT_MISSION2>> | CALLFORWARD | <<CALLFORWARD_ID_MISSION2>> |
| <<LAYOUT_MISSION2>> | LOUDSPEAKER | <<LOUDSPEAKER_ID_MISSION2>> |
| <<LAYOUT_MISSION2>> | SETTINGS    | <<SETTINGS_ID_MISSION2>>    |
| <<LAYOUT_MISSION2>> | MONITORING  | <<MONITORING_ID_MISSION2>>  |
| <<LAYOUT_MISSION2>> | EDIT        | <<EDIT_ID_MISSION2>>        |
| <<LAYOUT_MISSION3>> | PHONEBOOK   | <<PHONEBOOK_ID_MISSION3>>   |
| <<LAYOUT_MISSION3>> | CALLHISTORY | <<CALLHISTORY_ID_MISSION3>> |
| <<LAYOUT_MISSION3>> | MISSIONS    | <<MISSIONS_ID_MISSION3>>    |
| <<LAYOUT_MISSION3>> | CALLFORWARD | <<CALLFORWARD_ID_MISSION3>> |
| <<LAYOUT_MISSION3>> | LOUDSPEAKER | <<LOUDSPEAKER_ID_MISSION3>> |
| <<LAYOUT_MISSION3>> | SETTINGS    | <<SETTINGS_ID_MISSION3>>    |
| <<LAYOUT_MISSION3>> | MONITORING  | <<MONITORING_ID_MISSION3>>  |
| <<LAYOUT_MISSION3>> | EDIT        | <<EDIT_ID_MISSION3>>        |
| <<LAYOUT_MISSION4>> | PHONEBOOK   | <<PHONEBOOK_ID_MISSION4>>   |
| <<LAYOUT_MISSION4>> | CALLHISTORY | <<CALLHISTORY_ID_MISSION4>> |
| <<LAYOUT_MISSION4>> | MISSIONS    | <<MISSIONS_ID_MISSION4>>    |
| <<LAYOUT_MISSION4>> | CALLFORWARD | <<CALLFORWARD_ID_MISSION4>> |
| <<LAYOUT_MISSION4>> | LOUDSPEAKER | <<LOUDSPEAKER_ID_MISSION4>> |
| <<LAYOUT_MISSION4>> | SETTINGS    | <<SETTINGS_ID_MISSION4>>    |
| <<LAYOUT_MISSION4>> | MONITORING  | <<MONITORING_ID_MISSION4>>  |
| <<LAYOUT_MISSION4>> | EDIT        | <<EDIT_ID_MISSION4>>        |
| <<LAYOUT_TWR>>      | PHONEBOOK   | <<PHONEBOOK_ID>>            |
| <<LAYOUT_TWR>>      | CALLHISTORY | <<CALLHISTORY_ID>>          |
| <<LAYOUT_TWR>>      | MISSIONS    | <<MISSIONS_ID>>             |
| <<LAYOUT_TWR>>      | CALLFORWARD | <<CALLFORWARD_ID>>          |
| <<LAYOUT_TWR>>      | MONITORING  | <<MONITORING_ID>>           |
| <<LAYOUT_GND>>      | PHONEBOOK   | <<PHONEBOOK_ID>>            |
| <<LAYOUT_GND>>      | CALLHISTORY | <<CALLHISTORY_ID>>          |
| <<LAYOUT_GND>>      | MISSIONS    | <<MISSIONS_ID>>             |
| <<LAYOUT_GND>>      | CALLFORWARD | <<CALLFORWARD_ID>>          |
| <<LAYOUT_GND>>      | MONITORING  | <<MONITORING_ID>>           |
| <<LAYOUT_APP>>      | PHONEBOOK   | <<PHONEBOOK_ID>>            |
| <<LAYOUT_APP>>      | CALLHISTORY | <<CALLHISTORY_ID>>          |
| <<LAYOUT_APP>>      | MISSIONS    | <<MISSIONS_ID>>             |
| <<LAYOUT_APP>>      | CALLFORWARD | <<CALLFORWARD_ID>>          |
| <<LAYOUT_APP>>      | MONITORING  | <<MONITORING_ID>>           |
| <<LAYOUT_SUP-TWR>>  | PHONEBOOK   | <<PHONEBOOK_ID>>            |
| <<LAYOUT_SUP-TWR>>  | CALLHISTORY | <<CALLHISTORY_ID>>          |
| <<LAYOUT_SUP-TWR>>  | MISSIONS    | <<MISSIONS_ID>>             |
| <<LAYOUT_SUP-TWR>>  | CALLFORWARD | <<CALLFORWARD_ID>>          |
| <<LAYOUT_SUP-TWR>>  | MONITORING  | <<MONITORING_ID>>           |
| <<LAYOUT_SUP-TWR>>  | SETTINGS    | <<SETTINGS_ID_SUP-TWR>>     |

Scenario: Define status key
Given the status key:
| source  | key                    | id                             |
| HMI OP1 | DISPLAY STATUS         | <<DISPLAY_STATUS_ID_MISSION1>> |
| HMI OP1 | DISPLAY STATUS 2       | <<DISPLAY_STATUS_ID_MISSION2>> |
| HMI OP1 | DISPLAY STATUS 3       | <<DISPLAY_STATUS_ID_MISSION3>> |
| HMI OP1 | DISPLAY STATUS 4       | <<DISPLAY_STATUS_ID_MISSION4>> |
| HMI OP1 | DISPLAY STATUS TWR     | <<DISPLAY_STATUS_ID_TWR>>      |
| HMI OP1 | DISPLAY STATUS GND     | <<DISPLAY_STATUS_ID_GND>>      |
| HMI OP1 | DISPLAY STATUS APP     | <<DISPLAY_STATUS_ID_APP>>      |
| HMI OP1 | DISPLAY STATUS SUP-TWR | <<DISPLAY_STATUS_ID_SUP-TWR>>  |
| HMI OP2 | DISPLAY STATUS         | <<DISPLAY_STATUS_ID_MISSION2>> |
| HMI OP2 | DISPLAY STATUS 1       | <<DISPLAY_STATUS_ID_MISSION1>> |
| HMI OP2 | DISPLAY STATUS 3       | <<DISPLAY_STATUS_ID_MISSION3>> |
| HMI OP2 | DISPLAY STATUS 4       | <<DISPLAY_STATUS_ID_MISSION4>> |
| HMI OP2 | DISPLAY STATUS TWR     | <<DISPLAY_STATUS_ID_TWR>>      |
| HMI OP3 | DISPLAY STATUS         | <<DISPLAY_STATUS_ID_MISSION3>> |
| HMI OP3 | DISPLAY STATUS 2       | <<DISPLAY_STATUS_ID_MISSION2>> |
| HMI OP3 | DISPLAY STATUS 1       | <<DISPLAY_STATUS_ID_MISSION1>> |
| HMI OP3 | DISPLAY STATUS 4       | <<DISPLAY_STATUS_ID_MISSION4>> |
| HMI OP3 | DISPLAY STATUS TWR     | <<DISPLAY_STATUS_ID_TWR>>      |
| HMI OP1 | NOTIFICATION DISPLAY   | <<NOTIFICATION_DISPLAY_ID>>    |
| HMI OP2 | NOTIFICATION DISPLAY   | <<NOTIFICATION_DISPLAY_ID>>    |
| HMI OP3 | NOTIFICATION DISPLAY   | <<NOTIFICATION_DISPLAY_ID>>    |

Scenario: Define call route selectors
Given the call route selectors:
| key       | id      |
| Default   | default |
| None      | none    |
| FrqUser   | frqUser |
| Gmail     | gmail   |
| Admin     | admin   |
| Super     | super   |
| Student   | student |
| Professor | prof    |
| Medic     | medic   |
| Mail      | mail    |

Scenario: Define call source and API URI
When define values in story data:
| name    | value            |
| HMI OP1 | <<HMI1_API.URI>> |
| HMI OP2 | <<HMI2_API.URI>> |
| HMI OP3 | <<HMI3_API.URI>> |

