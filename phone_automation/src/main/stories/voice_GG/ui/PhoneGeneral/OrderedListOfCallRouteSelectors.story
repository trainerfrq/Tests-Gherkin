Narrative:
As an operator
I want to add up to 10 Call Route Selectors
So I can verify that the Call Route Selector List is ordered

Meta: @AfterStory: ../includes/@SwitchToInitialMission.story

Scenario: Booking profiles
Given booked profiles:
| profile | group | host           | identifier |
| javafx  | hmi   | <<CLIENT1_IP>> | HMI OP1    |
| javafx  | hmi   | <<CLIENT2_IP>> | HMI OP2    |

Scenario: Verify Call Route Selector List for mission MAN-NIGHT-TACT
When HMI OP1 presses function key PHONEBOOK
Then HMI OP1 verifies the Call Route Selector list for mission MAN-NIGHT-TACT from /configuration-files/<<systemName>>/missions.json
When HMI OP1 closes phonebook

Scenario: Change mission for HMI OP2
When HMI OP1 presses function key MISSIONS
Then HMI OP1 changes current mission to mission WEST-EXEC
Then HMI OP1 activates mission
Then waiting for 5 seconds

Scenario: Verify Call Route Selector List for mission WEST-EXEC
When HMI OP1 presses function key PHONEBOOK
Then HMI OP1 verifies the Call Route Selector list for mission WEST-EXEC from /configuration-files/<<systemName>>/missions.json
When HMI OP1 closes phonebook

Scenario: Change mission for HMI OP2
When HMI OP1 presses function key MISSIONS
Then HMI OP1 changes current mission to mission EAST-EXEC
Then HMI OP1 activates mission
Then waiting for 5 seconds

Scenario: Verify Call Route Selector List for mission EAST-EXEC
When HMI OP1 presses function key PHONEBOOK
Then HMI OP1 verifies the Call Route Selector list for mission EAST-EXEC from /configuration-files/<<systemName>>/missions.json
When HMI OP1 closes phonebook
