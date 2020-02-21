Scenario: Define the DA keys
Given the DA keys:
| source | target                | id                        |
| WS1    | OP1                   |                           |
| WS1    | OP2                   | <<PhyOpPos1_CWP2>>        |
| WS1    | OP3                   | <<PhyOpPos1_CWP3>>        |
| WS1    | IA - OP1              |                           |
| WS1    | IA - OP2              | <<IA_PhyOpPos1_CWP2>>     |
| WS1    | IA - OP3              | <<IA_PhyOpPos1_CWP3>>     |
| WS1    | ROLE2                 | <<ROLE1_ROLE2>>           |
| WS1    | ROLE1                 | <<PhyOpPos1_ROLE1>>       |
| WS1    | ROLE2-ALIAS           | <<ROLE1_ROLE2ALIAS1>>     |
| WS1    | Madoline              | <<IA_PhyOpPos1_Madoline>> |
| WS1    | OP2(as Mission3)      | <<MISSION3_CWP2>>         |
| WS1    | OP2(as ActiveMission) | <<ACTIVE1_CWP2>>          |
| WS1    | OP1(as Mission3)      | <<MISSION3_CWP1>>         |
| WS1    | IA - <<ROLE_2_NAME>>  | <<IA_ACTIVE_MISSION2>>    |
| WS1    | <<ROLE_2_NAME>>       | <<ACTIVE1_MISSION2>>      |
| WS1    | <<ROLE_3_NAME>>       | <<ACTIVE2_MISSION3>>      |
| WS1    | OP3 - <<ROLE_2_NAME>> | <<ACTIVE3_MISSION2>>      |
| WS2    | OP1                   | <<PhyOpPos2_CWP1>>        |
| WS2    | OP2                   |                           |
| WS2    | OP3                   | <<PhyOpPos2_CWP3>>        |
| WS2    | IA - OP1              | <<IA_PhyOpPos2_CWP1>>     |
| WS2    | IA - OP2              | <<IA_PhyOpPos2_CWP2>>     |
| WS2    | IA - OP3              | <<IA_PhyOpPos2_CWP3>>     |
| WS2    | ROLE1                 | <<PhyOpPos2_ROLE1>>       |
| WS2    | ROLE1(as ROLE2)       | <<ROLE2_ROLE1>>           |
| WS2    | ROLE1-ALIAS           | <<PhyOpPos2_ROLE1ALIAS1>> |
| WS2    | ROLE1-ALIAS(as ROLE2) | <<ROLE2_ROLE1ALIAS1>>     |
| WS2    | IA - ROLE1            | <<IA_PhyOpPos2_ROLE1>>    |
| WS2    | OP1(as Mission2)      | <<ACTIVE2_CWP1>>          |
| WS2    | <<ROLE_1_NAME>>       | <<IA_ACTIVE2_MISSION1>>   |
| WS2    | <<ROLE_3_NAME>>       | <<ACTIVE2_MISSION3>>      |
| WS3    | OP1                   | <<PhyOpPos3_CWP1>>        |
| WS3    | OP2                   | <<PhyOpPos3_CWP2>>        |
| WS3    | <<ROLE_2_NAME>>       | <<ACTIVE3_MISSION2>>      |
| WS3    | IA - OP1              | <<IA_PhyOpPos3_CWP1>>     |
| WS3    | IA - OP2              | <<IA_PhyOpPos3_CWP2>>     |

