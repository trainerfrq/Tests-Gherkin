Scenario: Booking profiles
Given booked profiles:
| profile | group | host           | identifier |
| javafx  | hmi   | <<CLIENT1_IP>> | HMI OP1    |
| javafx  | hmi   | <<CLIENT2_IP>> | HMI OP2    |
| javafx  | hmi   | <<CLIENT3_IP>> | HMI OP3    |

Scenario: Op1 closes seetings popup window
Then HMI OP1 closes settings popup

Scenario: Op2 closes seetings popup window
Then HMI OP2 closes settings popup

Scenario: Op3 closes seetings popup window
Then HMI OP3 closes settings popup
