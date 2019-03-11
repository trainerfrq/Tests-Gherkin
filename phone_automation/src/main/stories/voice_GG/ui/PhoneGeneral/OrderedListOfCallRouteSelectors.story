Narrative:
As an operator
I want to add up to 10 Call Route Selectors
So I can verify that the Call Route Selector are order in the same manner as they were configured

Scenario: Booking profiles
Given booked profiles:
| profile | group | host           | identifier |
| javafx  | hmi   | <<CLIENT1_IP>> | HMI OP1    |
| javafx  | hmi   | <<CLIENT2_IP>> | HMI OP2    |
| javafx  | hmi   | <<CLIENT3_IP>> | HMI OP3    |

Scenario: Verify Call Route Selector List for mission MAN-NIGHT-TACT
		  @REQUIREMENTS:GID-2877918
When HMI OP1 presses function key PHONEBOOK
Then HMI OP1 verifies the Call Route Selector list for mission MAN-NIGHT-TACT from /configuration-files/<<systemName>>/missions.json

Scenario: Op1 closes phone book
When HMI OP1 closes phonebook

Scenario: Verify Call Route Selector List for mission WEST-EXEC
When HMI OP2 presses function key PHONEBOOK
Then HMI OP2 verifies the Call Route Selector list for mission WEST-EXEC from /configuration-files/<<systemName>>/missions.json

Scenario: Op2 closes phone book
When HMI OP2 closes phonebook

Scenario: Verify Call Route Selector List for mission EAST-EXEC
When HMI OP3 presses function key PHONEBOOK
Then HMI OP3 verifies the Call Route Selector list for mission EAST-EXEC from /configuration-files/<<systemName>>/missions.json

Scenario: Op3 closes phone book
When HMI OP3 closes phonebook
