Scenario: Define the DA keys
Given the DA keys:
| source  | target                | id                               |
| HMI OP1 | OP1                   |                               |
| HMI OP1 | OP2                   | 100                              |
| HMI OP1 | OP3                   | 102                              |
| HMI OP1 | IA - OP1              |                               |
| HMI OP1 | IA - OP2              | 107                              |
| HMI OP1 | IA - OP3              | <<OP1_IA_OP3_ID>>                |
| HMI OP1 | ROLE2                 | 104                              |
| HMI OP1 | ROLE1                 | 105                              |
| HMI OP1 | ROLE2-ALIAS           | 106                              |
| HMI OP1 | Madoline              | 109                              |
| HMI OP1 | OP2(as Mission3)      | 101                              |
| HMI OP1 | OP2(as ActiveMission) | <<OP1_ACTIVE_MISSION_OP2_ID>>    |
| HMI OP1 | OP1(as Mission3)      | 103                              |
| HMI OP1 | <<MISSION_2_NAME>>    | <<OP1_IA_MISSION2_ID>>           |
| HMI OP2 | OP1                   | 110                              |
| HMI OP2 | OP2                   |                               |
| HMI OP2 | OP3                   | 111                              |
| HMI OP2 | IA - OP1              | 118                              |
| HMI OP2 | IA - OP2              | 119                              |
| HMI OP2 | IA - OP3              | 121                              |
| HMI OP2 | ROLE1                 | 112                              |
| HMI OP2 | ROLE1(as ROLE2)       | 113                              |
| HMI OP2 | ROLE1-ALIAS           | 114                              |
| HMI OP2 | ROLE1-ALIAS(as ROLE2) | 115                              |
| HMI OP2 | IA - ROLE1            | 117                              |
| HMI OP2 | OP1(as Mission2)      | <<OP2_OP1_MISSION2_ID>>          |
| HMI OP2 | <<MISSION_1_NAME>>    | <<OP2_IA_MISSION1_ID>>        |  |
| HMI OP3 | OP1                   | <<OP3_OP1_ID>>                   |
| HMI OP3 | OP2                   | <<OP3_OP2_ID>>                   |
| HMI OP3 | IA - OP1              | <<OP3_IA_OP1_ID>>                |
| HMI OP3 | IA - OP2              | <<OP3_IA_OP2_ID>>                |

Scenario: Define grid widget keys
Given the grid widget keys:
| layout              | id                   |
| <<LAYOUT_MISSION1>> | <<GRID_ID_MISSION1>> |
| <<LAYOUT_MISSION2>> | <<GRID_ID_MISSION2>> |
| <<LAYOUT_MISSION3>> | <<GRID_ID_MISSION3>> |

Scenario: Define function keys
Given the function keys:
| layout              | key         | id                       |
| <<LAYOUT_MISSION1>> | PHONEBOOK   | f1                       |
| <<LAYOUT_MISSION1>> | CALLHISTORY | f2                       |
| <<LAYOUT_MISSION1>> | MISSIONS    | f3                       |
| <<LAYOUT_MISSION1>> | CALLFORWARD | f4                       |
| <<LAYOUT_MISSION1>> | LOUDSPEAKER | f5                       |
| <<LAYOUT_MISSION1>> | SETTINGS    | <<SETTINGS_ID_MISSION1>> |
| <<LAYOUT_MISSION2>> | PHONEBOOK   | f1                       |
| <<LAYOUT_MISSION2>> | CALLHISTORY | f2                       |
| <<LAYOUT_MISSION2>> | MISSIONS    | f3                       |
| <<LAYOUT_MISSION2>> | CALLFORWARD | f4                       |
| <<LAYOUT_MISSION2>> | LOUDSPEAKER | f5                       |
| <<LAYOUT_MISSION2>> | SETTINGS    | <<SETTINGS_ID_MISSION2>> |
| <<LAYOUT_MISSION3>> | PHONEBOOK   | f1                       |
| <<LAYOUT_MISSION3>> | CALLHISTORY | f2                       |
| <<LAYOUT_MISSION3>> | MISSIONS    | f3                       |
| <<LAYOUT_MISSION3>> | CALLFORWARD | f4                       |
| <<LAYOUT_MISSION3>> | LOUDSPEAKER | f5                       |
| <<LAYOUT_MISSION3>> | SETTINGS    | <<SETTINGS_ID_MISSION3>> |

Scenario: Define status key
Given the status key:
| source  | key            | id      |
| HMI OP1 | DISPLAY STATUS | status1 |
| HMI OP2 | DISPLAY STATUS | status1 |
| HMI OP3 | DISPLAY STATUS | status1 |

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

