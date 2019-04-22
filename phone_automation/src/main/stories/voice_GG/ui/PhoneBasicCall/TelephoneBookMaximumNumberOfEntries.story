Narrative:
As an operator
I want to count the number of phonebook entries
So I can check the total number of entries are available for the call

Scenario: Booking profiles
Given booked profiles:
| profile | group | host           | identifier |
| javafx  | hmi   | <<CLIENT2_IP>> | HMI OP2    |

Scenario: Operator opens phonebook
When HMI OP2 presses function key PHONEBOOK
Then HMI OP2 verifies that phone book call button is disabled
Then HMI OP2 verify that call route selector shows Default

Scenario: Operator checks if the phone book contains the specified number of entries
		  @REQUIREMENTS:GID-2877942
Given the totalNumber of phonebook entries from /configuration-files/<<systemName>>/phoneBook.json
Then HMI OP2 verifies that the total number of phonebook entries is totalNumber

Scenario: Operator closes phonebook
Then HMI OP2 closes phonebook
