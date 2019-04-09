Narrative:
As an operator
I want to check the number of phonebook entries

Scenario: Booking profiles
Given booked profiles:
| profile | group | host           | identifier |
| javafx  | hmi   | <<CLIENT1_IP>> | HMI OP1    |

Scenario: Operator opens phonebook
When HMI OP1 presses function key PHONEBOOK
Then HMI OP1 verifies that phone book call button is disabled
Then HMI OP1 verify that call route selector shows Default

Scenario: Operator checks if the phone book contains the specified number of entries
Then HMI OP1 verifies that the total number of phonebook entries is 1008

Scenario: Operator closes phonebook
Then HMI OP1 closes phonebook
