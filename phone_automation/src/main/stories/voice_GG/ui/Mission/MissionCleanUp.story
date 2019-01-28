Narrative:
Clean-up story, to make sure that operator positions are back to the initial missions

Scenario: Booking profiles
Given booked profiles:
| profile | group | host           | identifier |
| javafx  | hmi   | <<CLIENT1_IP>> | HMI OP1    |
| javafx  | hmi   | <<CLIENT2_IP>> | HMI OP2    |
| javafx  | hmi   | <<CLIENT3_IP>> | HMI OP3    |

Scenario: Change mission
When HMI OP1 presses function key MISSIONS
Then HMI OP1 changes current mission to mission MAN-NIGHT-TACT
Then HMI OP1 activates mission
Then waiting for 5 seconds

Scenario: Verify operator mission
Then HMI OP1 has in the display status section mission the assigned mission MAN-NIGHT-TACT

Scenario: Change to mission
When HMI OP2 presses function key MISSIONS
Then HMI OP2 changes current mission to mission WEST-EXEC
Then HMI OP2 activates mission
Then waiting for 5 seconds

Scenario: Verify operator mission
Then HMI OP2 has in the display status section mission the assigned mission WEST-EXEC

Scenario: Change to mission
When HMI OP3 presses function key MISSIONS
Then HMI OP3 changes current mission to mission EAST-EXEC
Then HMI OP3 activates mission
Then waiting for 5 seconds

Scenario: Verify operator mission
Then HMI OP3 has in the display status section mission the assigned mission EAST-EXEC
