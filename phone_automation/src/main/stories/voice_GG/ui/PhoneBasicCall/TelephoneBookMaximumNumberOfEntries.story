Narrative:
As an operator
I want to search as I type in the telephone book
So I can easily and quickly find a telephone book entry I want to call

Scenario: Booking profiles
Given booked profiles:
| profile | group | host           | identifier |
| javafx  | hmi   | <<CLIENT1_IP>> | HMI OP1    |

Scenario: Operator opens phonebook
When HMI OP1 presses function key PHONEBOOK
Then HMI OP1 verifies that phone book call button is disabled
Then HMI OP1 verify that call route selector shows Default

Scenario: Caller checks if the phone book contains the specified number of entries
Then HMI OP1 verifies that phonebook list has 1000 items
