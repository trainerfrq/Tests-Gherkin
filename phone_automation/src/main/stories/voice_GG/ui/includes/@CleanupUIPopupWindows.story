Scenario: Booking profiles
Given booked profiles:
| profile | group | host           | identifier |
| javafx  | hmi   | <<CLIENT1_IP>> | HMI OP1    |
| javafx  | hmi   | <<CLIENT2_IP>> | HMI OP2    |
| javafx  | hmi   | <<CLIENT3_IP>> | HMI OP3    |

Scenario: OP1 closes all popup windows if they are still open
Then HMI OP1 does a clean up by closing callHistory window
Then HMI OP1 does a clean up by closing mission window
Then HMI OP1 does a clean up by closing phonebook window
Then HMI OP1 does a clean up by closing conferenceList window
Then HMI OP1 does a clean up by closing maintenance window
Then HMI OP1 does a clean up by closing settings window

Scenario: OP2 closes all popup windows if they are still open
Then HMI OP2 does a clean up by closing callHistory window
Then HMI OP2 does a clean up by closing mission window
Then HMI OP2 does a clean up by closing phonebook window
Then HMI OP2 does a clean up by closing conferenceList window
Then HMI OP2 does a clean up by closing maintenance window
Then HMI OP2 does a clean up by closing settings window

Scenario: OP3 closes all popup windows if they are still open
Then HMI OP3 does a clean up by closing callHistory window
Then HMI OP3 does a clean up by closing mission window
Then HMI OP3 does a clean up by closing phonebook window
Then HMI OP3 does a clean up by closing conferenceList window
Then HMI OP3 does a clean up by closing maintenance window
Then HMI OP3 does a clean up by closing settings window
