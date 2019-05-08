Scenario: Booking profiles
Given booked profiles:
| profile | group | host           | identifier |
| javafx  | hmi   | <<CLIENT1_IP>> | HMI OP1    |
| javafx  | hmi   | <<CLIENT2_IP>> | HMI OP2    |
| javafx  | hmi   | <<CLIENT3_IP>> | HMI OP3    |

Scenario: OP1 closes all popup windows if they are still open
Then if HMI OP1 has notification Conference call active it does a clean up by closing conferenceList window

Scenario: OP2 closes all popup windows if they are still open
Then if HMI OP2 has notification Conference call active it does a clean up by closing conferenceList window

Scenario: OP3 closes all popup windows if they are still open
Then if HMI OP3 has notification Conference call active it does a clean up by closing conferenceList window
