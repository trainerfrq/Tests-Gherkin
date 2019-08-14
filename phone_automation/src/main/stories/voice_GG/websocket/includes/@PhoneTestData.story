Scenario: Define the DA keys
Given the DA keys:
| source | target                | id                            |
| WS1    | OP1                   |                               |
| WS1    | OP2                   | 100                           |
| WS1    | OP3                   | 102                           |
| WS1    | IA - OP1              |                               |
| WS1    | IA - OP2              | 107                           |
| WS1    | IA - OP3              | <<OP1_IA_OP3_ID>>             |
| WS1    | ROLE2                 | 104                           |
| WS1    | ROLE1                 | 105                           |
| WS1    | ROLE2-ALIAS           | 106                           |
| WS1    | Madoline              | 109                           |
| WS1    | OP2(as ActiveMission) | <<OP1_ACTIVE_MISSION_OP2_ID>> |
| WS2    | OP1                   | 110                           |
| WS2    | OP2                   |                               |
| WS2    | OP3                   | 111                           |
| WS2    | IA - OP1              | 118                           |
| WS2    | IA - OP2              | 119                           |
| WS2    | IA - OP3              | 121                           |
| WS2    | ROLE1                 | 112                           |
| WS2    | ROLE1(as ROLE2)       | 113                           |
| WS2    | ROLE1-ALIAS           | 114                           |
| WS2    | ROLE1-ALIAS(as ROLE2) | 115                           |
| WS2    | IA - ROLE1            | 117                           |
| WS3    | OP1                   | <<OP3_OP1_ID>>                |
| WS3    | OP2                   | <<OP3_OP2_ID>>                |
| WS3    | IA - OP1              | <<OP3_IA_OP1_ID>>             |
| WS3    | IA - OP2              | <<OP3_IA_OP2_ID>>             |

