Scenario: Operators change the mission
When the following operators do a change mission to missions from the table:
| hmiOperator | mission            |
| HMI OP2     | <<MISSION_1_NAME>> |
| HMI OP1     | <<MISSION_2_NAME>> |

Scenario: Operators verify that mission change was done successfully
Then verify that the following operators changed the mission successfully:
| hmiOperator | mission            |
| HMI OP2     | <<MISSION_1_NAME>> |
| HMI OP1     | <<MISSION_2_NAME>> |