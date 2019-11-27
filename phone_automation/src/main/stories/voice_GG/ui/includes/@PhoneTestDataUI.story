Scenario: Define the DA keys
Given the DA keys:
| source  | target                | id                            |
| HMI OP1 | OP1                   | <<PhyOpPos1_CWP1>>            |
| HMI OP1 | OP2                   | <<PhyOpPos1_CWP2>>            |
| HMI OP1 | OP3                   | <<PhyOpPos1_CWP3>>            |
| HMI OP1 | IA - OP1              |                               |
| HMI OP1 | IA - OP2              | <<IA_PhyOpPos1_CWP2>>         |
| HMI OP1 | IA - OP3              | <<IA_PhyOpPos1_CWP3>>         |
| HMI OP1 | ROLE2                 | <<ROLE1_ROLE2>>               |
| HMI OP1 | ROLE1                 | <<PhyOpPos1_ROLE1>>           |
| HMI OP1 | ROLE2-ALIAS           | <<ROLE1_ROLE2ALIAS1>>         |
| HMI OP1 | Madoline              | <<IA_PhyOpPos1_Madoline>>     |
| HMI OP1 | OP2(as Mission3)      | <<MISSION3_CWP2>>             |
| HMI OP1 | OP2(as ActiveMission) | <<ACTIVE1_CWP2>>              |
| HMI OP1 | OP1(as Mission3)      | <<MISSION3_CWP1>>             |
| HMI OP1 | IA - <<ROLE_2_NAME>>  | <<IA_ACTIVE_MISSION2>>        |
| HMI OP1 | <<ROLE_2_NAME>>       | <<ACTIVE1_MISSION2>>          |
| HMI OP1 | <<ROLE_3_NAME>>       | <<ACTIVE2_MISSION3>>          |
| HMI OP1 | OP3 - <<ROLE_2_NAME>> | <<ACTIVE3_MISSION2>>          |
| HMI OP2 | OP1                   | <<PhyOpPos2_CWP1>>            |
| HMI OP2 | OP2                   |                               |
| HMI OP2 | OP3                   | <<PhyOpPos2_CWP3>>            |
| HMI OP2 | IA - OP1              | <<IA_PhyOpPos2_CWP1>>         |
| HMI OP2 | IA - OP2              | <<IA_PhyOpPos2_CWP2>>         |
| HMI OP2 | IA - OP3              | <<IA_PhyOpPos2_CWP3>>         |
| HMI OP2 | ROLE1                 | <<PhyOpPos2_ROLE1>>           |
| HMI OP2 | ROLE1(as ROLE2)       | <<ROLE2_ROLE1>>               |
| HMI OP2 | ROLE1-ALIAS           | <<PhyOpPos2_ROLE1ALIAS1>>     |
| HMI OP2 | ROLE1-ALIAS(as ROLE2) | <<ROLE2_ROLE1ALIAS1>>         |
| HMI OP2 | IA - ROLE1            | <<IA_PhyOpPos2_ROLE1>>        |
| HMI OP2 | OP1(as Mission2)      | <<ACTIVE2_CWP1>>              |
| HMI OP2 | IA - <<ROLE_1_NAME>>  | <<IA_ACTIVE2_MISSION1>>       |
| HMI OP2 | <<ROLE_3_NAME>>       | <<ACTIVE2_MISSION3>>          |
| HMI OP2 | OP1(as Mission3)      | <<PhyOpPos3_CWP1>>            |
| HMI OP2 | OP3(as Mission1)      | <<PhyOpPos1_CWP3>>            |
| HMI OP2 | RoleEmergency(tower)  | <<PhyOpPos2_RoleEmergency_MISSION4>>   |
| HMI OP2 | RoleEmergency         | <<PhyOpPos2_RoleEmergency>>   |
| HMI OP3 | OP1                   | <<PhyOpPos3_CWP1>>            |
| HMI OP3 | OP2                   | <<PhyOpPos3_CWP2>>            |
| HMI OP3 | ROLE1                 | <<PhyOpPos3_ROLE1>>           |
| HMI OP3 | <<ROLE_2_NAME>>       | <<ACTIVE3_MISSION2>>          |
| HMI OP3 | IA - OP1              | <<IA_PhyOpPos3_CWP1>>         |
| HMI OP3 | IA - OP2              | <<IA_PhyOpPos3_CWP2>>         |
| HMI OP3 | <<ROLE_1_NAME>>       | <<ACTIVE3_MISSION1>>          |
| HMI OP3 | OP1-urgent            | <<PhyOpPos3_CWP1_urgent>>     |

Scenario: Define grid widget keys
Given the grid widget keys:
| layout              | id                   |
| <<LAYOUT_MISSION1>> | <<GRID_ID_MISSION1>> |
| <<LAYOUT_MISSION2>> | <<GRID_ID_MISSION2>> |
| <<LAYOUT_MISSION3>> | <<GRID_ID_MISSION3>> |
| <<LAYOUT_MISSION4>> | <<GRID_ID_MISSION4>> |

Scenario: Define function keys
Given the function keys:
| layout              | key         | id                         |
| <<LAYOUT_MISSION1>> | PHONEBOOK   | <<PHONEBOOK_ID>>           |
| <<LAYOUT_MISSION1>> | CALLHISTORY | <<CALLHISTORY_ID>>         |
| <<LAYOUT_MISSION1>> | MISSIONS    | <<MISSIONS_ID>>            |
| <<LAYOUT_MISSION1>> | CALLFORWARD | <<CALLFORWARD_ID>>         |
| <<LAYOUT_MISSION1>> | LOUDSPEAKER | <<LOUDSPEAKER_ID>>         |
| <<LAYOUT_MISSION1>> | SETTINGS    | <<SETTINGS_ID_MISSION1>>   |
| <<LAYOUT_MISSION1>> | MONITORING  | <<MONITORING_ID_MISSION1>> |
| <<LAYOUT_MISSION1>> | EDIT        | <<EDIT_ID_MISSION1>>       |
| <<LAYOUT_MISSION2>> | PHONEBOOK   | <<PHONEBOOK_ID>>           |
| <<LAYOUT_MISSION2>> | CALLHISTORY | <<CALLHISTORY_ID>>         |
| <<LAYOUT_MISSION2>> | MISSIONS    | <<MISSIONS_ID>>            |
| <<LAYOUT_MISSION2>> | CALLFORWARD | <<CALLFORWARD_ID>>         |
| <<LAYOUT_MISSION2>> | LOUDSPEAKER | <<LOUDSPEAKER_ID>>         |
| <<LAYOUT_MISSION2>> | SETTINGS    | <<SETTINGS_ID_MISSION2>>   |
| <<LAYOUT_MISSION2>> | MONITORING  | <<MONITORING_ID_MISSION2>> |
| <<LAYOUT_MISSION2>> | EDIT        | <<EDIT_ID_MISSION2>>       |
| <<LAYOUT_MISSION3>> | PHONEBOOK   | <<PHONEBOOK_ID>>           |
| <<LAYOUT_MISSION3>> | CALLHISTORY | <<CALLHISTORY_ID>>         |
| <<LAYOUT_MISSION3>> | MISSIONS    | <<MISSIONS_ID>>            |
| <<LAYOUT_MISSION3>> | CALLFORWARD | <<CALLFORWARD_ID>>         |
| <<LAYOUT_MISSION3>> | LOUDSPEAKER | <<LOUDSPEAKER_ID>>         |
| <<LAYOUT_MISSION3>> | SETTINGS    | <<SETTINGS_ID_MISSION3>>   |
| <<LAYOUT_MISSION3>> | MONITORING  | <<MONITORING_ID_MISSION3>> |
| <<LAYOUT_MISSION3>> | EDIT        | <<EDIT_ID_MISSION3>>       |
| <<LAYOUT_MISSION4>> | PHONEBOOK   | <<PHONEBOOK_ID>>           |
| <<LAYOUT_MISSION4>> | CALLHISTORY | <<CALLHISTORY_ID>>         |
| <<LAYOUT_MISSION4>> | MISSIONS    | <<MISSIONS_ID>>            |
| <<LAYOUT_MISSION4>> | CALLFORWARD | <<CALLFORWARD_ID>>         |
| <<LAYOUT_MISSION4>> | LOUDSPEAKER | <<LOUDSPEAKER_ID>>         |
| <<LAYOUT_MISSION4>> | SETTINGS    | <<SETTINGS_ID_MISSION4>>   |
| <<LAYOUT_MISSION4>> | MONITORING  | <<MONITORING_ID_MISSION4>> |
| <<LAYOUT_MISSION4>> | EDIT        | <<EDIT_ID_MISSION4>>       |

Scenario: Define status key
Given the status key:
| source  | key                  | id                          |
| HMI OP1 | DISPLAY STATUS       | <<DISPLAY_STATUS_ID>>       |
| HMI OP2 | DISPLAY STATUS       | <<DISPLAY_STATUS_ID>>       |
| HMI OP3 | DISPLAY STATUS       | <<DISPLAY_STATUS_ID>>       |
| HMI OP1 | NOTIFICATION DISPLAY | <<NOTIFICATION_DISPLAY_ID>> |
| HMI OP2 | NOTIFICATION DISPLAY | <<NOTIFICATION_DISPLAY_ID>> |
| HMI OP3 | NOTIFICATION DISPLAY | <<NOTIFICATION_DISPLAY_ID>> |

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

